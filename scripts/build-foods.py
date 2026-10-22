# Builds www/foods.json, the everyday foods behind Nutrition > Search foods.
# Source: the USDA FoodData Central "SR Legacy" rows (public domain) of the
# tempo-food-db npm package (CC-BY-4.0, TempoLife). Each row is
# [name, calories per 100 g, protein g per 100 g] plus 1 for common foods,
# which the search lists first.
# Usage: npm pack tempo-food-db && tar xzf tempo-food-db-*.tgz
#        python3 scripts/build-foods.py package/data/tempolife-foods.json
import json, sys
COMMON = {
    'Apples, raw, with skin', 'Bananas, raw', 'Oranges, raw', 'Avocados, raw', 'Strawberries, raw', 'Blueberries, raw',
    'Grapes, red or green (European type, such as Thompson seedless), raw', 'Broccoli, raw', 'Carrots, raw', 'Spinach, raw',
    'Egg, whole, cooked, hard-boiled', 'Egg, whole, cooked, scrambled', 'Rice, white, long-grain, cooked', 'Rice, brown, long-grain, cooked',
    'Chicken, breast, meat only, cooked, roasted', 'Turkey, whole, meat only, cooked, roasted', 'Bread, whole-wheat', 'Bread, white',
    'Milk, whole, 3.25% milkfat, with added vitamin D', 'Oats', 'Pasta, cooked, without added salt',
    'Potatoes, baked, flesh and skin, without salt', 'Sweet potato, cooked, baked in skin, flesh, without salt',
    'Yogurt, Greek, plain, nonfat', 'Yogurt, plain, whole milk', 'Cheese, cheddar', 'Peanut butter, smooth style, with salt', 'Nuts, almonds',
    'Pork, cured, bacon, cooked, baked', 'Beef, ground, 85% lean meat / 15% fat, patty, cooked', 'Fish, salmon, Atlantic, farmed, cooked',
    'Fish, tuna, light, canned in water, drained solids', 'Beans, black, mature seeds, cooked, boiled',
}
rows, seen = [], set()
for x in json.load(open(sys.argv[1])):
    if x.get('source') != 'usda_sr_legacy' or x.get('kcal_per_100g') is None:
        continue
    n = x['name'].strip()
    if n.lower() in seen:
        continue
    seen.add(n.lower())
    r = [n, round(x['kcal_per_100g']), round(x['protein_g'] or 0, 1)]
    if n in COMMON:
        r.append(1)
    rows.append(r)
rows.sort(key=lambda r: r[0].lower())
missing = COMMON - {r[0] for r in rows}
if missing:
    sys.exit('common foods not found: %s' % sorted(missing))
json.dump(rows, open('www/foods.json', 'w'), separators=(',', ':'), ensure_ascii=False)
print(len(rows), 'foods,', sum(len(r) == 4 for r in rows), 'common')
