# Clear data
User.destroy_all
Sku.destroy_all
Category.destroy_all
ASkuDetail.destroy_all
BSkuDetail.destroy_all
CSkuDetail.destroy_all

# Admin User
User.create!(email: 'admin@example.com', password: 'password', admin: true)
puts "Admin user created: admin@example.com / password"

# Channel A: 制冷设备 (Cooling)
cat_a = Category.create!(name: '制冷设备', category_kind: 'a')
cat_a1 = Category.create!(name: '商用冰箱', parent: cat_a, category_kind: 'a')
cat_a1_1 = Category.create!(name: '立式冰箱', parent: cat_a1, category_kind: 'a')
cat_a1_1_1 = Category.create!(name: '单门展示柜', parent: cat_a1_1, category_kind: 'a')
cat_a1_1_2 = Category.create!(name: '双门展示柜', parent: cat_a1_1, category_kind: 'a')

sku_a1 = Sku.create!(
  name: '高端立式单门冷柜 SN-1000',
  category: cat_a1_1_1,
  price: 5999.00,
  stock: 50,
  status: 'active'
)
sku_a1.skuable.update!(
  net_capacity: '1000L',
  unit_dimensions: '1200x750x2000 mm',
  packaging_dimensions: '1300x850x2100 mm',
  voltage_frequency: '220V/50Hz',
  temp_range: '-18°C ~ -22°C',
  standard_features: "全铜管散热\n智能控温系统\n进口压缩机"
)
puts "Channel A data created"

# Channel B: 烹饪设备 (Cooking)
cat_b = Category.create!(name: '烹饪设备', category_kind: 'b')
cat_b1 = Category.create!(name: '万能蒸烤箱', parent: cat_b, category_kind: 'b')

sku_b1 = Sku.create!(
  name: '智能触控蒸烤一体机 CO-500',
  category: cat_b1,
  price: 8800.00,
  stock: 20,
  status: 'active'
)
sku_b1.skuable.update!(
  unit_dimensions: '900x800x1100 mm'
)
puts "Channel B data created"

# Channel C: 不锈钢餐饮用品 (Stainless Steel)
cat_c = Category.create!(name: '不锈钢餐饮用品', category_kind: 'c')
cat_c1 = Category.create!(name: '燃气灶具', parent: cat_c, category_kind: 'c')

sku_c1 = Sku.create!(
  name: '工业级六头燃气灶 GS-600',
  category: cat_c1,
  price: 3500.00,
  stock: 30,
  status: 'active'
)
sku_c1.skuable.update!(
  burners_and_control_method: '6 Burners, Manual Control',
  gas_type: 'LPG / NG',
  intake_tube_pressure: '2.8 kPa',
  per_btu: '25,000 BTU/h',
  total_btu: '150,000 BTU/h',
  regulator: 'Included',
  work_area: '1200x800 mm',
  exterior_dimensions: '1200x900x850 mm',
  key_features: "加厚不锈钢面板\n高效铸铁炉头\n可调节防滑脚座"
)
puts "Channel C data created"
