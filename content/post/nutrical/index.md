---
title: Nutrical
subtitle: All about nutrition and food
description: "nutrical, python"
date: '2024-05-25'
aliases:
    - /nutrical
katex: false
# draft: true
ignoreToc: "h3,h4,h5,h6"
tags:
- python
format: 
   gfm:
      output-file: "index"
      output-ext: "md"
      variant: +yaml_metadata_block+raw_html
      df-print: tibble
# filters:
  # - quarto
  # - list-table.lua
jupyter: python3
editor:
   render-on-save: false
---

Load [`nutrical`](https://github.com/liao961120/nutrical) for nutrition
calculation.

``` python
from nutrical import Ingredient, Recipe
from nutrical.utils import UREG
```

## Imei whole wheat toast

``` python
toast = Ingredient("Imei Toast",
    amount = '300g',
    calories = 3 * 264,
    protein = 3 * 11.4,
    fiber = 3 * 8.1
)
toast = toast * (2/7) + 0 * toast
toast
```

      servings  amount        calories    fiber    protein
    ----------  ----------  ----------  -------  ---------
             1  85.71 gram      226.29     6.94       9.77

## Home-made Yogurt

- Protein: 6g / 100g

``` python
powder = Ingredient("powered milk", amount='32g', protein=7.8)
water = Ingredient("water", amount='200g')
probio = Ingredient("probiotics (yogurt)", amount="75g", protein=2.7)

target_protein_concentration = 6
target_total_weight = 700
protein_from_milk = target_protein_concentration * (target_total_weight/100) - 2.7
powder_to_add = powder.to(protein=protein_from_milk)
water_weight = UREG(f"{target_total_weight} gram") - probio.total_amount - powder_to_add.total_amount

yogurt = Recipe("yogurt", components=[
    powder_to_add,
    water.to(amount=water_weight),
    probio
])
yogurt
```

    <Recipe (yogurt)>

        servings  amount        protein
      ----------  ----------  ---------
               1  700.0 gram         42

      [INGREDIENTS]
            name                   servings  amount         protein
        --  -------------------  ----------  -----------  ---------
         1  powered milk            5.03846  161.23 gram       39.3
         2  water                   2.31885  463.77 gram
         3  probiotics (yogurt)     1        75 gram            2.7
