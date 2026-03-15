# Resources: Sales

## Constants

| Name | Type | Value |
|---|---|---|
| Sales.DefaultCurrency | String | EUR |

## Scheduled Events

| Event | Schedule | Target flow |
|---|---|---|
| SE_Recalculate | 0 0 * * * | Sales.ACT_Order_Create |

## Other Resources

| Kind | Name |
|---|---|
| JavaAction | Sales.Utils |
