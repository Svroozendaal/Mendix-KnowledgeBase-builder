import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { createLogger } from '../../logger.js';

const log = createLogger('QuestionClassifier');

export type ClassificationCategory =
  | 'direct-entity'
  | 'direct-page'
  | 'direct-flow'
  | 'direct-artifact'
  | 'architecture'
  | 'comparison'
  | 'unknown';

export interface ClassificationResult {
  category: ClassificationCategory;
  /** Artifact names extracted from the question (e.g. ["TraineeLocation", "US2"]) */
  detectedArtifacts: string[];
  /** Suggested search queries to pre-run (e.g. ["TraineeLocation", "US2_Answer"]) */
  suggestedSearches: string[];
  /** Confidence: high if a clear artifact name was matched, low otherwise */
  confidence: 'high' | 'low';
}

/** System prompt hints per classification category. */
export const CLASSIFICATION_HINTS: Partial<Record<ClassificationCategory, string>> = {
  'direct-entity': 'Hint: The user is asking about a specific artifact. Relevant KB content has been pre-loaded. Check it before using tools.',
  'direct-page': 'Hint: The user is asking about a specific artifact. Relevant KB content has been pre-loaded. Check it before using tools.',
  'direct-flow': 'Hint: The user is asking about a specific artifact. Relevant KB content has been pre-loaded. Check it before using tools.',
  'direct-artifact': 'Hint: The user is asking about a specific artifact. Relevant KB content has been pre-loaded. Check it before using tools.',
  'architecture': 'Hint: This is a broad architecture question. Start from APP_OVERVIEW.md or MODULE_LANDSCAPE.md.',
};

const ARCHITECTURE_KEYWORDS = [
  'architecture', 'overview', 'security', 'modules', 'how does the app',
  'what does the app', 'what does this app', 'module landscape', 'call graph',
  'how are modules', 'what is this app', 'how is the app',
];

const USER_STORY_PATTERN = /\b(?:us|user\s*story|story)\s*(\d+)\b/gi;

interface ArtifactIndex {
  /** Entity short names and qualified names, mapped to their category. */
  entities: Map<string, string>;
  /** Page short names and qualified names. */
  pages: Map<string, string>;
  /** Flow short names and qualified names. */
  flows: Map<string, string>;
}

export class QuestionClassifier {
  private index: ArtifactIndex | null = null;

  constructor(private kbRoot: string) {}

  /** Build the artifact index from the seeded KB context (ROUTING.md, route index files). */
  async initialize(): Promise<void> {
    const entities = new Map<string, string>();
    const pages = new Map<string, string>();
    const flows = new Map<string, string>();

    // Parse each route index file
    await this.parseRouteIndex(join(this.kbRoot, 'routes', 'by-entity.md'), entities);
    await this.parseRouteIndex(join(this.kbRoot, 'routes', 'by-page.md'), pages);
    await this.parseRouteIndex(join(this.kbRoot, 'routes', 'by-flow.md'), flows);

    this.index = { entities, pages, flows };
    log.info('Artifact index built', {
      entities: entities.size,
      pages: pages.size,
      flows: flows.size,
    });
  }

  /** Classify a user question. */
  classify(question: string): ClassificationResult {
    if (!this.index) {
      log.warn('Classifier not initialised — returning unknown');
      return { category: 'unknown', detectedArtifacts: [], suggestedSearches: [], confidence: 'low' };
    }

    const lowerQuestion = question.toLowerCase();

    // 1. Check for user story patterns (direct-artifact)
    const storyMatches = this.extractUserStories(question);

    // 2. Check for named artifacts in each category
    const entityHits = this.matchArtifacts(lowerQuestion, this.index.entities);
    const pageHits = this.matchArtifacts(lowerQuestion, this.index.pages);
    const flowHits = this.matchArtifacts(lowerQuestion, this.index.flows);

    const allHits = [...storyMatches, ...entityHits, ...pageHits, ...flowHits];
    const uniqueHits = [...new Set(allHits)];

    // 3. If multiple distinct artifact types are found → comparison
    const hitTypes = new Set<string>();
    if (storyMatches.length > 0) hitTypes.add('artifact');
    if (entityHits.length > 0) hitTypes.add('entity');
    if (pageHits.length > 0) hitTypes.add('page');
    if (flowHits.length > 0) hitTypes.add('flow');

    if (uniqueHits.length >= 2) {
      return {
        category: 'comparison',
        detectedArtifacts: uniqueHits,
        suggestedSearches: uniqueHits,
        confidence: 'high',
      };
    }

    // 4. Single artifact match → classify by type
    if (storyMatches.length === 1) {
      return {
        category: 'direct-artifact',
        detectedArtifacts: storyMatches,
        suggestedSearches: storyMatches,
        confidence: 'high',
      };
    }

    if (entityHits.length === 1) {
      return {
        category: 'direct-entity',
        detectedArtifacts: entityHits,
        suggestedSearches: entityHits,
        confidence: 'high',
      };
    }

    if (pageHits.length === 1) {
      return {
        category: 'direct-page',
        detectedArtifacts: pageHits,
        suggestedSearches: pageHits,
        confidence: 'high',
      };
    }

    if (flowHits.length === 1) {
      return {
        category: 'direct-flow',
        detectedArtifacts: flowHits,
        suggestedSearches: flowHits,
        confidence: 'high',
      };
    }

    // 5. Architecture keywords
    if (ARCHITECTURE_KEYWORDS.some(kw => lowerQuestion.includes(kw))) {
      return {
        category: 'architecture',
        detectedArtifacts: [],
        suggestedSearches: [],
        confidence: 'high',
      };
    }

    // 6. Fallback
    return { category: 'unknown', detectedArtifacts: [], suggestedSearches: [], confidence: 'low' };
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /** Extract US/user story references from the question text. */
  private extractUserStories(question: string): string[] {
    const results: string[] = [];
    let match: RegExpExecArray | null;
    // Reset lastIndex since the regex is global
    USER_STORY_PATTERN.lastIndex = 0;
    while ((match = USER_STORY_PATTERN.exec(question)) !== null) {
      results.push(`US${match[1]}`);
    }
    return results;
  }

  /**
   * Match known artifact names against the question text.
   * Returns the qualified names (e.g. "MyFirstModule.TraineeLocation") of matched artifacts.
   * Uses case-insensitive exact word-boundary matching on the short name.
   */
  private matchArtifacts(lowerQuestion: string, artifactMap: Map<string, string>): string[] {
    const matched: string[] = [];
    for (const [lowerName, qualifiedName] of artifactMap) {
      // Word-boundary match: the artifact name must appear as a distinct token
      const pattern = new RegExp(`\\b${this.escapeRegex(lowerName)}\\b`);
      if (pattern.test(lowerQuestion)) {
        matched.push(qualifiedName);
      }
    }
    return matched;
  }

  /** Parse a route index markdown table and extract artifact names. */
  private async parseRouteIndex(filePath: string, target: Map<string, string>): Promise<void> {
    let content: string;
    try {
      content = await readFile(filePath, 'utf-8');
    } catch {
      log.warn(`Route index not found: ${filePath}`);
      return;
    }

    const lines = content.split('\n');
    for (const line of lines) {
      // Skip header and separator rows
      if (!line.startsWith('|') || line.includes('---')) continue;

      const cells = line.split('|').map(c => c.trim()).filter(Boolean);
      if (cells.length < 2) continue;

      // First cell is the qualified name (e.g. "MyFirstModule.Course" or "Administration.ChangeMyPassword")
      const qualifiedName = cells[0];
      if (!qualifiedName || qualifiedName.toLowerCase() === 'entity'
        || qualifiedName.toLowerCase() === 'page'
        || qualifiedName.toLowerCase() === 'flow') {
        continue; // header row
      }

      // Store the qualified name mapped from its lowercase form
      target.set(qualifiedName.toLowerCase(), qualifiedName);

      // Also store the short name (after the dot) for easier matching
      const dotIndex = qualifiedName.lastIndexOf('.');
      if (dotIndex !== -1) {
        const shortName = qualifiedName.slice(dotIndex + 1);
        // Only store short name if it's reasonably specific (>= 3 chars)
        // and doesn't collide with an existing entry from a different qualified name
        if (shortName.length >= 3) {
          const lowerShort = shortName.toLowerCase();
          if (!target.has(lowerShort)) {
            target.set(lowerShort, qualifiedName);
          } else {
            // Collision — remove the short name to avoid ambiguity
            // (keep only qualified names for disambiguation)
            const existing = target.get(lowerShort)!;
            if (existing !== qualifiedName) {
              target.delete(lowerShort);
            }
          }
        }
      }
    }
  }

  private escapeRegex(str: string): string {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }
}
