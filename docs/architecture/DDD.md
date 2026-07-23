# DDD

## Bounded context

Instead of thinking in terms of a single "restaurant domain," let's identify several independent domains, each with its own model.

| Bounded Context | Responsability                        | Database   |
| :-------------- | :------------------------------------ | :--------- |
| Orders          | Order lifecycle management            | PostgreSQL |
| Kitchen         | Food preparation and work stations    | PostgreSQL |
| Inventory       | Inventory and movement of ingredients | PostgreSQL |
| Recipes         | Definition of recipes and ingredients | MongoDB    |
| Billing         | Billing and Payments                  | PostgreSQL |
| Analytics       | Metrics and event history             | MongoDB    |
