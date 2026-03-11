# Clear existing data except Users
Sku.destroy_all
Category.destroy_all
ASkuDetail.destroy_all
BSkuDetail.destroy_all
CSkuDetail.destroy_all

# Admin User (if not exists)
#User.find_or_create_by!(email: 'admin@example.com') do |user|
#user.password = 'password'
#user.admin = true
#end
#puts "Admin user check completed."

# Root Category
root_refrig = Category.create!(name: 'Commercial Refrigeration', category_kind: 'a')
puts "Root category: Commercial Refrigeration"

def create_skus(category, skus_data)
  skus_data.each do |data|
    s = Sku.new(
      name: data[:sku],
      category: category,
      status: 'active',
      visible: true
    )
    s.skuable = ASkuDetail.new(
      net_capacity: data[:net_capacity],
      unit_dimensions: data[:unit_dim],
      packaging_dimensions: data[:pack_dim],
      voltage_frequency: data[:voltage],
      temp_range: data[:temp],
      standard_features: "#{data[:features]}\nRefrigerant: #{data[:refrigerant]}"
    )
    s.save!
  end
end

def create_b_skus(category, skus_data)
  skus_data.each do |data|
    s = Sku.new(
      name: data[:sku],
      category: category,
      status: 'active',
      visible: true
    )

    s.skuable = BSkuDetail.new(
      burners_and_control_method: data[:burners],
      gas_type: data[:gas_type],
      intake_tube_pressure: data[:pressure],
      per_btu: data[:btu_per],
      total_btu: data[:total_btu],
      regulator: data[:regulator],
      work_area: data[:work_area],
      exterior_dimensions: data[:unit_dim],
      unit_dimensions: data[:unit_dim],
      standard_features: data[:features]
    )
    s.save!
  end
end

def create_c_skus(category, skus_data)
  skus_data.each do |data|
    s = Sku.new(
      name: data[:sku],
      category: category,
      status: 'active',
      visible: true
    )

    s.skuable = CSkuDetail.new(
      unit_dimensions: data[:unit_dim],
      product_dimensions: data[:prod_dim],
      sink_bowl_dimensions: data[:bowl_dim],
      sink_depth: data[:depth],
      leg_bracing: data[:leg_bracing],
      faucet_and_drain: data[:faucet],
      standard_features: data[:features]
    )
    s.save!
  end
end

# 1. REACH-IN
reach_in = Category.create!(name: 'REACH-IN', parent: root_refrig, category_kind: 'a')

# 1.1 Bottom Mount Reach-Ins Refrigerators
bm_reach_in_refrig = Category.create!(name: 'Bottom Mount Reach-Ins Refrigerators', parent: reach_in, category_kind: 'a')
bm_refrig_solid = Category.create!(name: 'Reach-In Solid Door', parent: bm_reach_in_refrig, category_kind: 'a')
create_skus(bm_refrig_solid, [
  { sku: 'VR-23D1', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "Hydrocarbon Refrigerant R290, Digital Temperature Control, Stainless Steel Interior & Exterior, Bottom-Mount Compressor, LED Interior Lighting, Self-Closing Solid Doors, Recessed Door Handles, Door Locks Standard, Heavy-Duty Casters, Removable Door Gaskets, Adjustable Shelving" },
  { sku: 'VR-49D2', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-72D3', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
bm_refrig_glass = Category.create!(name: 'Reach-In Glass Door', parent: bm_reach_in_refrig, category_kind: 'a')
create_skus(bm_refrig_glass, [
  { sku: 'VR-23G1', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-49G2', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-72G3', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])

# 1.2 Bottom Mount Reach-Ins Freezers
bm_reach_in_freezer = Category.create!(name: 'Bottom Mount Reach-Ins Freezers', parent: reach_in, category_kind: 'a')
bm_freezer_solid = Category.create!(name: 'Reach-In Solid Door (Freezer)', parent: bm_reach_in_freezer, category_kind: 'a')
create_skus(bm_freezer_solid, [
  { sku: 'VF-23D1', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-49D2', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-72D3', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])
bm_freezer_glass = Category.create!(name: 'Reach-In Glass Door (Freezer)', parent: bm_reach_in_freezer, category_kind: 'a')
create_skus(bm_freezer_glass, [
  { sku: 'VF-23G1', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-49G2', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-72G3', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])

# 1.3 Top Mount Reach-Ins (Coming Soon)
tm_reach_in_refrig = Category.create!(name: 'Top Mount Reach-Ins Refrigerators', parent: reach_in, category_kind: 'a')
tm_refrig_solid = Category.create!(name: 'Reach-In Solid Door (Top Mount)', parent: tm_reach_in_refrig, category_kind: 'a')
create_skus(tm_refrig_solid, [
  { sku: 'VR-650D1', net_capacity: '610L', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-1410D2', net_capacity: '940L', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-2010D3', net_capacity: '', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
tm_reach_in_freezer = Category.create!(name: 'Top Mount Reach-Ins Freezers', parent: reach_in, category_kind: 'a')
tm_freezer_solid = Category.create!(name: 'Reach-In Solid Door (Top Mount Freezer)', parent: tm_reach_in_freezer, category_kind: 'a')
create_skus(tm_freezer_solid, [
  { sku: 'VF-650D1', net_capacity: '', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-1410D2', net_capacity: '', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-2010D3', net_capacity: '', unit_dim: '', pack_dim: '', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])

# 2. MERCHANDISERS
merch = Category.create!(name: 'MERCHANDISERS', parent: root_refrig, category_kind: 'a')
merch_refrig = Category.create!(name: 'Glass Door Merchandisers-Refrigerators', parent: merch, category_kind: 'a')
create_skus(merch_refrig, [
  { sku: 'VR-23G1-BL', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-49G2-BL', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-72G3-BL', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-23G1-B', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-49G2-B', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'VR-72G3-B', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
merch_freezer = Category.create!(name: 'Glass Door Merchandisers-Freezers', parent: merch, category_kind: 'a')
create_skus(merch_freezer, [
  { sku: 'VF-23G1-BL', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-49G2-BL', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-72G3-BL', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-23G1-B', net_capacity: '20.5 Cu. Ft.', unit_dim: '27 3/16" × 31 1/2" × 82"', pack_dim: '30 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-49G2-B', net_capacity: '44.5 Cu. Ft.', unit_dim: '54 1/8" × 31 1/2"× 82"', pack_dim: '57 1/8"× 35"× 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'VF-72G3-B', net_capacity: '68.5 Cu. Ft.', unit_dim: '81 1/8"× 31 1/2" × 82"', pack_dim: '83 11/16" × 35" × 84 13/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])

# 3. UNDERCOUNTER
undercounter = Category.create!(name: 'UNDERCOUNTER', parent: root_refrig, category_kind: 'a')
uc_refrig = Category.create!(name: 'Undercounter-Refrigerators', parent: undercounter, category_kind: 'a')
uc_refrig_drawer = Category.create!(name: 'Drawered Refrigerator (Rear Breathing)', parent: uc_refrig, category_kind: 'a')
create_skus(uc_refrig_drawer, [
  { sku: 'SR-28D2', net_capacity: '6.8 Cu. Ft.', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Compact undercounter size, Stainless Steel exterior & Interior, Heavy duty casters (brakes or without brakes), Removable door gasket, High-density polyurethane insulation, Recessed door handles, Self-closing doors" }
])
uc_refrig_rear_solid = Category.create!(name: 'Solid Door (Rear Breathing)', parent: uc_refrig, category_kind: 'a')
create_skus(uc_refrig_rear_solid, [
  { sku: 'SR-28D1', net_capacity: '6.8 Cu.Ft', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-36D2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 25 11/32" × 35 5/8"', pack_dim: '39 1/2" x 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-48D2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 25 11/32" × 35 5/8"', pack_dim: '51 9/16" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-60D2', net_capacity: '17.0 Cu.Ft', unit_dim: '60 7/16" × 25 11/32" × 35 5/8"', pack_dim: '62 5/8"× 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-72D3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 25 11/32" × 35 5/8"', pack_dim: '75 5/8" × 33 1/16" ×3 9 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
uc_refrig_rear_glass = Category.create!(name: 'Glass Door (Rear Breathing)', parent: uc_refrig, category_kind: 'a')
create_skus(uc_refrig_rear_glass, [
  { sku: 'SR-28G1', net_capacity: '6.8 Cu.Ft', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-36G2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 25 11/32" × 35 5/8"', pack_dim: '39 1/2" x 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-48G2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 25 11/32" × 35 5/8"', pack_dim: '51 9/16" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-60G2', net_capacity: '17.0 Cu.Ft', unit_dim: '60 7/16" × 25 11/32" × 35 5/8"', pack_dim: '62 5/8"× 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-72G3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 25 11/32" × 35 5/8"', pack_dim: '75 5/8" × 33 1/16" ×3 9 3/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
uc_refrig_side_solid = Category.create!(name: 'Solid Door (Side Breathing)', parent: uc_refrig, category_kind: 'a')
create_skus(uc_refrig_side_solid, [
  { sku: 'SR-44D1', net_capacity: '12.8 Cu.Ft', unit_dim: '48 7/16" × 32 3/16" × 35"', pack_dim: '51 9/16" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-67D2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 15/32" × 32 3/16" × 35"', pack_dim: '72 5/8" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-93D3', net_capacity: '31.0Cu.Ft', unit_dim: '93 3/16" × 32 3/16" × 35"', pack_dim: '96 1/8 × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
uc_refrig_side_glass = Category.create!(name: 'Glass Door (Side Breathing)', parent: uc_refrig, category_kind: 'a')
create_skus(uc_refrig_side_glass, [
  { sku: 'SR-44G1', net_capacity: '12.8 Cu.Ft', unit_dim: '48 7/16" × 32 3/16" × 35"', pack_dim: '51 9/16" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-67G2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 15/32" × 32 3/16" × 35"', pack_dim: '72 5/8" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SR-93G3', net_capacity: '31.0Cu.Ft', unit_dim: '93 3/16" × 32 3/16" × 35"', pack_dim: '96 1/8 × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])

uc_freezer = Category.create!(name: 'Undercounter-Freezers', parent: undercounter, category_kind: 'a')
uc_freezer_drawer = Category.create!(name: 'Drawered Freezer (Rear Breathing)', parent: uc_freezer, category_kind: 'a')
create_skus(uc_freezer_drawer, [
  { sku: 'SF-28D2', net_capacity: '6.8 Cu. Ft.', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control -8°~-2°F, Compact undercounter size, Stainless Steel exterior & Interior, Heavy duty casters, Removable door gasket, High-density polyurethane insulation, Recessed door handles, Self-closing doors" }
])
uc_freezer_rear_solid = Category.create!(name: 'Solid Door (Rear Breathing)', parent: uc_freezer, category_kind: 'a')
create_skus(uc_freezer_rear_solid, [
  { sku: 'SF-28D1', net_capacity: '6.8 Cu.Ft', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-36D2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 25 11/32" × 35 5/8"', pack_dim: '39 1/2" x 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-48D2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 25 11/32" × 35 5/8"', pack_dim: '51 9/16" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-60D2', net_capacity: '17.0 Cu.Ft', unit_dim: '60 7/16" × 25 11/32" × 35 5/8"', pack_dim: '62 5/8"× 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-72D3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 25 11/32" × 35 5/8"', pack_dim: '75 5/8" × 33 1/16" ×3 9 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])
uc_freezer_rear_glass = Category.create!(name: 'Glass Door (Rear Breathing)', parent: uc_freezer, category_kind: 'a')
create_skus(uc_freezer_rear_glass, [
  { sku: 'SF-28G1', net_capacity: '6.8 Cu.Ft', unit_dim: '27 11/16" × 25 11/32" × 35 5/8"', pack_dim: '30 1/2" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-36G2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 25 11/32" × 35 5/8"', pack_dim: '39 1/2" x 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-48G2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 25 11/32" × 35 5/8"', pack_dim: '51 9/16" × 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-60G2', net_capacity: '17.0 Cu.Ft', unit_dim: '60 7/16" × 25 11/32" × 35 5/8"', pack_dim: '62 5/8"× 33 1/16" × 39 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-72G3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 25 11/32" × 35 5/8"', pack_dim: '75 5/8" × 33 1/16" ×3 9 3/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])
uc_freezer_side_solid = Category.create!(name: 'Solid Door (Side Breathing)', parent: uc_freezer, category_kind: 'a')
create_skus(uc_freezer_side_solid, [
  { sku: 'SF-44D1', net_capacity: '12.8 Cu.Ft', unit_dim: '48 7/16" × 32 3/16" × 35"', pack_dim: '51 9/16" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-67D2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 15/32" × 32 3/16" × 35"', pack_dim: '72 5/8" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-93D3', net_capacity: '31.0Cu.Ft', unit_dim: '93 3/16" × 32 3/16" × 35"', pack_dim: '96 1/8 × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])
uc_freezer_side_glass = Category.create!(name: 'Glass Door (Side Breathing)', parent: uc_freezer, category_kind: 'a')
create_skus(uc_freezer_side_glass, [
  { sku: 'SF-44G1', net_capacity: '12.8 Cu.Ft', unit_dim: '48 7/16" × 32 3/16" × 35"', pack_dim: '51 9/16" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-67G2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 15/32" × 32 3/16" × 35"', pack_dim: '72 5/8" × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'SF-93G3', net_capacity: '31.0Cu.Ft', unit_dim: '93 3/16" × 32 3/16" × 35"', pack_dim: '96 1/8 × 36 3/8" × 39"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])

# 4. FOOD PREP TABLES
cat_food_prep = Category.create!(name: 'FOOD PREP TABLES', parent: root_refrig, category_kind: 'a')
cat_sandwich = Category.create!(name: 'Sandwich Salad Refrigerators', parent: cat_food_prep, category_kind: 'a')
cat_sandwich_solid_rear = Category.create!(name: 'Solid Door (Rear Breathing)', parent: cat_sandwich, category_kind: 'a')
create_skus(cat_sandwich_solid_rear, [
  { sku: 'SUR-28D1', net_capacity: '6.8 Cu. Ft.', unit_dim: '27 11/16" × 30" × 42 15/16"', pack_dim: '30 7/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Compact undercounter size, Stainless Steel exterior & Interior, Heavy duty casters, Removable door gasket, High-density polyurethane insulation, Recessed door handles, Self-closing doors, 1 adjustable shelf per section" },
  { sku: 'SUR-36D2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 30" × 42 15/16"', pack_dim: '39 5/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-48D2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 30" × 42 15/16"', pack_dim: '51 3/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-60D2', net_capacity: '17.0Cu.Ft', unit_dim: '60 7/16" × 30" × 42 15/16"', pack_dim: '63 3/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-72D3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 30" × 42 15/16"', pack_dim: '75 5/8" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_sandwich_solid_side = Category.create!(name: 'Solid Door (Side Breathing)', parent: cat_sandwich, category_kind: 'a')
create_skus(cat_sandwich_solid_side, [
  { sku: 'SUR-44D1', net_capacity: '12.8 Cu.Ft', unit_dim: '48 3/8" × 32 1/4" × 42 5/16"', pack_dim: '51 3/16" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-67D2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 1/2" × 32 1/4" × 42 5/16"', pack_dim: '72 1/4" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-93D3', net_capacity: '31.0Cu.Ft', unit_dim: '93 3/16" × 32 1/4" × 42 5/16"', pack_dim: '96" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_sandwich_mega_rear = Category.create!(name: 'Mega-Top Solid Door (Rear Breathing)', parent: cat_sandwich, category_kind: 'a')
create_skus(cat_sandwich_mega_rear, [
  { sku: 'SUR-28D1-3', net_capacity: '6.8 Cu. Ft.', unit_dim: '27 11/16" × 35 11/16" × 45 1/4"', pack_dim: '30 7/16" × 36 5/8" × 48 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Stainless Steel exterior & Interior with Mega Top, Heavy duty casters, Removable door gasket, High-density polyurethane insulation, Recessed door handles, Self-closing doors, 1 adjustable shelf per section" },
  { sku: 'SUR-36D2-3', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 35 11/16" × 45 1/4"', pack_dim: '39 5/16" × 36 5/8" × 48 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-48D2-3', net_capacity: '12.2 Cu.Ft', unit_dim: '60 7/16" × 35 11/16" × 45 1/4"', pack_dim: '51 3/16" × 36 5/8" × 48 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-60D2-3', net_capacity: '17.0Cu.Ft', unit_dim: '48 7/16" × 35 11/16" × 45 1/4"', pack_dim: '63 3/16" × 36 5/8" × 48 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-72D3-3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 35 11/16" × 45 1/4"', pack_dim: '75 5/8" × 36 5/8" × 48 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_sandwich_mega_side = Category.create!(name: 'Mega-Top Solid Door (Side Breathing)', parent: cat_sandwich, category_kind: 'a')
create_skus(cat_sandwich_mega_side, [
  { sku: 'SUR-44D1-3', net_capacity: '12.8 Cu.Ft', unit_dim: '48 3/8" × 35 11/16" × 44 1/2"', pack_dim: '51 3/16" × 36 5/8" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-67D2-3', net_capacity: '17.7 Cu.Ft', unit_dim: '69 1/2" × 36 11/16" × 44 1/2"', pack_dim: '72 1/4" × 36 5/8" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'SUR-93D3-3', net_capacity: '31 Cu.Ft', unit_dim: '93 3/16" × 35 11/16" × 44 1/2"', pack_dim: '96.0" × 36 5/8" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])

cat_pizza = Category.create!(name: 'Pizza Prep Table Refrigerators', parent: cat_food_prep, category_kind: 'a')
cat_pizza_solid_rear = Category.create!(name: 'Solid Door (Rear Breathing)', parent: cat_pizza, category_kind: 'a')
create_skus(cat_pizza_solid_rear, [
  { sku: 'PUR-28D1', net_capacity: '6.8 Cu. Ft.', unit_dim: '27 11/16" × 30" × 43 7/8"', pack_dim: '30 7/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Compact undercounter size, Stainless Steel exterior & Interior, Heavy duty casters, Removable door gasket, High-density polyurethane insulation, Recessed door handles, Self-closing doors, 1 adjustable shelf per section" },
  { sku: 'PUR-36D2', net_capacity: '8.3 Cu.Ft', unit_dim: '36 9/16" × 30" × 43 7/8"', pack_dim: '39 5/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PUR-48D2', net_capacity: '12.2 Cu.Ft', unit_dim: '48 7/16" × 30" × 43 7/8"', pack_dim: '51 3/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PUR-60D2', net_capacity: '17.0Cu.Ft', unit_dim: '60 7/16" × 30" × 43 7/8"', pack_dim: '63 3/16" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PUR-72D3', net_capacity: '18.8 Cu.Ft', unit_dim: '72 7/8" × 30" × 43 7/8"', pack_dim: '75 5/8" × 32 11/16" × 45 11/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_pizza_solid_side = Category.create!(name: 'Solid Door (Side Breathing)', parent: cat_pizza, category_kind: 'a')
create_skus(cat_pizza_solid_side, [
  { sku: 'PUR-44D1', net_capacity: '12.9 Cu.Ft', unit_dim: '48 7/16" × 32 5/16" × 43 5/16"', pack_dim: '51 3/16" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PUR-67D2', net_capacity: '17.7 Cu.Ft', unit_dim: '69 1/2" × 32 5/16" × 43 5/16"', pack_dim: '72 1/4" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PUR-93D3', net_capacity: '31.1 Cu.Ft', unit_dim: '93 3/16" × 32 5/16" × 43 5/16"', pack_dim: '96" × 35 1/16" × 46 1/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])

# 5. CHEF BASES
cat_chef_base = Category.create!(name: 'CHEF BASES', parent: root_refrig, category_kind: 'a')
cat_chef_drawered_narrow = Category.create!(name: 'Drawered Refrigerator (Narrow Unit Room)', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_drawered_narrow, [
  { sku: 'TRCBR/L-36D2', net_capacity: '5.5 Cu.Ft', unit_dim: '35 3/4" x 32 1/8" x 25 1/4"', pack_dim: '38 3/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Side-mounted compressor behind front grill, Stainless Steel exterior & Interior, Heavy duty casters, Removable door gasket" },
  { sku: 'TRCBR/L-48D2', net_capacity: '8.5 Cu.Ft', unit_dim: '47 3/4" x 32 1/8" x 25 1/4"', pack_dim: '50 3/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-52D2', net_capacity: '10.0 Cu.Ft', unit_dim: '52 1/2" x 32 1/8" x 25 1/4"', pack_dim: '55 1/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-72D4', net_capacity: '14.9 Cu.Ft', unit_dim: '72 1/8" x 32 1/8" x 25 1/4"', pack_dim: '74 13/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-82D4', net_capacity: '18.9 Cu.Ft', unit_dim: '83 3/4" x 32 1/8" x 25 1/5"', pack_dim: '86 7/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-96D4', net_capacity: '21.0 Cu.Ft', unit_dim: '96 9/16" x 32 1/8" x 25 1/5"', pack_dim: '98 7/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_chef_narrow_extended = Category.create!(name: 'Drawered Refrigerator (Narrow Unit Room, Extended Top)', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_narrow_extended, [
  { sku: 'TRCBR/L-36D2-E', net_capacity: '5.5 Cu.Ft', unit_dim: '41 5/8" x 32 1/8" x 25 1/4"', pack_dim: '44 7/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 refrigerant, Extended top surface, Side-mounted compressor, Stainless Steel exterior & Interior, Heavy duty casters" },
  { sku: 'TRCBR/L-48D2-E', net_capacity: '8.5 Cu.Ft', unit_dim: '52 3/8" x 32 1/8" x 25 1/4"', pack_dim: '55 5/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-52D2-E', net_capacity: '10.0 Cu.Ft', unit_dim: '58 3/8" x 32 1/8" x 25 1/4"', pack_dim: '61 5/8" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-72D4-E', net_capacity: '14.9 Cu.Ft', unit_dim: '78 1/16" x 32 1/8" x 25 1/4"', pack_dim: '81 13/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-82D4-E', net_capacity: '18.9 Cu.Ft', unit_dim: '89 1/16" x 32 1/8" x 25 1/4"', pack_dim: '93 7/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'TRCBR/L-96D4-E', net_capacity: '21.0 Cu.Ft', unit_dim: '102 1/2" x 32 1/8" x 25 1/5"', pack_dim: '105 7/16" × 34 13/16" × 28 3/8"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_chef_drawered = Category.create!(name: 'Drawered Refrigerator', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_drawered, [
  { sku: 'PRCBR/L-36D2', net_capacity: '5.5 Cu.Ft', unit_dim: '36 1/8" x 33 11/16" x 26 7/16"', pack_dim: '38 3/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 hydrocarbon refrigerant, Digital temperature control 33°-39°F, Side-mounted compressor, Stainless Steel exterior & Interior, Heavy duty casters, Removable door gasket" },
  { sku: 'PRCBR/L-48D2', net_capacity: '9.0 Cu.Ft', unit_dim: '48 1/8" x 33 11/16" x 26 7/16"', pack_dim: '50 3/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-60D2', net_capacity: '12.4 Cu.Ft', unit_dim: '60 1/8" x 33 11/16" x 26 7/16"', pack_dim: '62 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-72D4', net_capacity: '17.7 Cu.Ft', unit_dim: '72 3/16" x 33 11/16" x 26 7/16"', pack_dim: '74 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-84D4', net_capacity: '18.9 Cu.Ft', unit_dim: '84 3/16" x 33 11/16" x 26 7/16"', pack_dim: '86 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-96D4', net_capacity: '22.3 Cu.Ft', unit_dim: '96 3/16" x 33 11/16" x 26 7/16"', pack_dim: '98 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_chef_drawered_extended = Category.create!(name: 'Drawered Refrigerator (Extended Top)', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_drawered_extended, [
  { sku: 'PRCBR/L-36D2-E', net_capacity: '5.5 Cu.Ft', unit_dim: '41 7/8" x 33 1/16" x 26 7/16"', pack_dim: '44 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290', features: "R290 refrigerant, Extended top, Side-mounted compressor, Stainless Steel exterior & Interior, Heavy duty casters" },
  { sku: 'PRCBR/L-48D2-E', net_capacity: '9.0 Cu.Ft', unit_dim: '53 7/8" x 33 1/16" x 26 7/16"', pack_dim: '57 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-60D2-E', net_capacity: '12.4 Cu.Ft', unit_dim: '65 7/8" x 33 11/16" x 26 7/16"', pack_dim: '68 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-72D4-E', net_capacity: '17.7 Cu.Ft', unit_dim: '77 7/8" x 33 11/16" x 26 7/16"', pack_dim: '80 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-84D4-E', net_capacity: '18.9 Cu.Ft', unit_dim: '89 7/8" x 33 11/16" x 26 7/16"', pack_dim: '92 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' },
  { sku: 'PRCBR/L-96D4-E', net_capacity: '22.3 Cu.Ft', unit_dim: '101 7/8" x 33 11/16" x 26 7/16"', pack_dim: '104 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '33℉ ~ 39℉', refrigerant: 'R290' }
])
cat_chef_freezer = Category.create!(name: 'Drawered Freezer', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_freezer, [
  { sku: 'PFCBR/L-36D2', net_capacity: '5.5 Cu.Ft', unit_dim: '36 1/8" x 33 11/16" x 26 7/16"', pack_dim: '38 3/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290', features: "Environmentally friendly R290 refrigerant, Stainless steel exterior & interior, Dixell digital controller, Temperature range -8℉~-2℉, Heavy duty stainless steel drawer slides, Recessed door handles, Magnetic door gaskets, Pre-installed casters, Reinforced stainless steel top, Gravity fed self closing drawers" },
  { sku: 'PFCBR/L-48D2', net_capacity: '9.0 Cu.Ft', unit_dim: '48 1/8" x 33 11/16" x 26 7/16"', pack_dim: '50 3/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-60D2', net_capacity: '12.4 Cu.Ft', unit_dim: '60 1/8" x 33 11/16" x 26 7/16"', pack_dim: '62 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-72D4', net_capacity: '17.7 Cu.Ft', unit_dim: '72 3/16" x 33 11/16" x 26 7/16"', pack_dim: '74 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-84D4', net_capacity: '18.9 Cu.Ft', unit_dim: '84 3/16" x 33 11/16" x 26 7/16"', pack_dim: '86 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-96D4', net_capacity: '22.3 Cu.Ft', unit_dim: '96 3/16" x 33 11/16" x 26 7/16"', pack_dim: '98 13/16" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])
cat_chef_freezer_extended = Category.create!(name: 'Drawered Freezer (Extended Top)', parent: cat_chef_base, category_kind: 'a')
create_skus(cat_chef_freezer_extended, [
  { sku: 'PFCBR/L-36D2-E', net_capacity: '5.5 Cu.Ft', unit_dim: '41 7/8" x 33 1/16" x 26 7/16"', pack_dim: '44 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290', features: "Environmentally friendly R290 refrigerant, Extended top, Stainless steel exterior & interior, Dixell digital controller, Temperature range -8℉~-2℉, Gravity fed self closing drawers" },
  { sku: 'PFCBR/L-48D2-E', net_capacity: '9.0 Cu.Ft', unit_dim: '53 7/8" x 33 1/16" x 26 7/16"', pack_dim: '57 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-60D2-E', net_capacity: '12.4 Cu.Ft', unit_dim: '65 7/8" x 33 11/16" x 26 7/16"', pack_dim: '68 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-72D4-E', net_capacity: '17.7 Cu.Ft', unit_dim: '77 1/8" x 33 11/16" x 26 7/16"', pack_dim: '80 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-84D4-E', net_capacity: '18.9 Cu.Ft', unit_dim: '89 7/8" x 33 11/16" x 26 7/16"', pack_dim: '92 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' },
  { sku: 'PFCBR/L-96D4-E', net_capacity: '22.3 Cu.Ft', unit_dim: '101 7/8" x 33 11/16" x 26 7/16"', pack_dim: '104 5/8" × 36 7/16" × 29 9/16"', voltage: '115V / 60Hz', temp: '- 8℉ ~ -2℉', refrigerant: 'R290' }
])

# Cooking Equipment (Category Kind 'b')
root_cooking = Category.create!(name: 'Cooking Equipment', category_kind: 'b')
puts "Root category: Cooking Equipment"

# B1. GAS Countertop Radiant Char Broiler
cat_char_broiler = Category.create!(name: 'GAS Countertop Radiant Char Broiler', parent: root_cooking, category_kind: 'b')
create_b_skus(cat_char_broiler, [
  { 
    sku: 'TH-QR-24', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 24000 (LP)', 
    total_btu: '100000 (NG) / 96000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '21 13/16” x 22“', 
    unit_dim: '24" x 30 5/16" x 18 5/16"', 
    features: "High-performance radiant burner system for uniform heat distribution\nDurable stainless-steel exterior designed for commercial environments\nHeavy-duty cast iron grates retain heat and enhance searing results\nIndividual burner controls allow precise temperature management\nFront-positioned grease collection tray simplifies cleaning and maintenance\nCompact countertop design with adjustable legs for flexible installation\nConfigurable for Natural Gas or Liquid Propane (specify at order)" 
  },
  { 
    sku: 'TH-QR-36', 
    burners: '6 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 24000 (LP)', 
    total_btu: '150000 (NG) / 144000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '32 5/8" x 22”', 
    unit_dim: '36" x 30 5/16" x 18 5/16"' 
  },
  { 
    sku: 'TH-QR-48', 
    burners: '8 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 24000 (LP)', 
    total_btu: '200000 (NG) / 192000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '43 5/16“ x 22"', 
    unit_dim: '48" x 30 5/16" x 18 5/16"' 
  }
])

# B2. Countertop GAS Griddle
cat_gas_griddle = Category.create!(name: 'Countertop GAS Griddle', parent: root_cooking, category_kind: 'b')
create_b_skus(cat_gas_griddle, [
  { 
    sku: 'TH-RGT-24', 
    burners: '2 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 19000 (LP)', 
    total_btu: '50000 (NG) / 38000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '24" x 24"', 
    unit_dim: '24" x 33" x 17 5/16"', 
    features: "High-efficiency gas burner system for even heat distribution\nDurable stainless steel construction for commercial use\nThick steel griddle plate ensures excellent heat retention\nIndependent manual controls for each heating zone\nFront grease drawer for quick and easy cleaning\nCompact countertop design with adjustable legs\nConfigurable for Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-RGT-36', 
    burners: '3 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 19000 (LP)', 
    total_btu: '75000 (NG) / 57000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '36" x 24"', 
    unit_dim: '36" x 33" x 17 5/16"' 
  },
  { 
    sku: 'TH-RGT-48', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '25000 (NG) / 19000 (LP)', 
    total_btu: '100000 (NG) / 76000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '48" x 24"', 
    unit_dim: '48" x 33" x 17 5/16"' 
  },
  { 
    sku: 'TH-VEG-1000', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '10000 (NG) / 9000 (LP)', 
    total_btu: '40000 (NG) / 36000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '39 3/16" x 21 13/16"', 
    unit_dim: '39 5/16“ x 27 1/2" x 15 3/4“', 
    features: "High-efficiency gas burner system for even heat distribution\nDurable stainless steel construction for commercial use\nThick steel griddle plate ensures excellent heat retention\nIndependent manual controls for each heating zone\nFront grease drawer for quick and easy cleaning\nCompact countertop design with adjustable legs\nConfigurable for Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-VEG-1200', 
    burners: '5 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '10000 (NG) / 9000 (LP)', 
    total_btu: '50000 (NG) / 45000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '47" x 21 13/16"', 
    unit_dim: '47 3/16” x 27 1/2" x 15 3/4“' 
  },
  { 
    sku: 'TH-VEG-1500', 
    burners: '6 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '10000 (NG) / 9000 (LP)', 
    total_btu: '60000 (NG) / 54000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '58 13/16” x 21 13/16"', 
    unit_dim: '59" x 27 1/2" x 15 3/4“' 
  },
  { 
    sku: 'TH-VEG-1800', 
    burners: '7 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '10000 (NG) / 9000 (LP)', 
    total_btu: '70000 (NG) / 63000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    work_area: '70 3/4” x 21 13/16"', 
    unit_dim: '70 13/16” x 27 1/2" x 15 3/4“' 
  }
])

# B3. GAS Floor Fryer
cat_gas_fryer = Category.create!(name: 'GAS Floor Fryer', parent: root_cooking, category_kind: 'b')
create_b_skus(cat_gas_fryer, [
  { 
    sku: 'TH-FY90', 
    burners: '3 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000', 
    total_btu: '90000', 
    pressure: '4"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '4"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '15 1/2” x 30 3/16" x 53 3/16"', 
    features: "High-efficiency gas burner system for rapid heat-up and recovery\nDurable stainless steel construction designed for commercial kitchens\nDeep fry pot with optimized heat transfer for consistent frying results\nLarge-capacity wire fry baskets for high-volume operation\nFront-mounted controls for safe and convenient operation\nAdjustable stainless steel legs for flexible installation\nAvailable in multiple oil capacities to match different output demands\nConfigurable for Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-FY120', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000', 
    total_btu: '120000', 
    pressure: '4"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '4"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '15 1/2” x 30 3/16" x 53 3/16"' 
  },
  { 
    sku: 'TH-FY150', 
    burners: '5 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000', 
    total_btu: '150000', 
    pressure: '4"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '4"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '21" x 30 3/16" x 53 3/16"' 
  }
])

# B4. GAS Stock Pot Ranges
cat_gas_range = Category.create!(name: 'GAS Stock Pot Ranges', parent: root_cooking, category_kind: 'b')
create_b_skus(cat_gas_range, [
  { 
    sku: 'TH-RB-2', 
    burners: '2 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000 (NG) / 24000 (LP)', 
    total_btu: '60000 (NG) / 48000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '12" x 30 5/16" x 14 13/16"', 
    features: "Heavy-duty cast iron burners for powerful and stable flame\nRugged stainless steel exterior designed for commercial kitchens\nIndependent manual controls for each burner\nRemovable burner grates for easy cleaning and service\nCompact countertop footprint with adjustable legs\nMultiple configurations available: 2, 4, or 6 burners\nCompatible with Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-RB-4', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000 (NG) / 24000 (LP)', 
    total_btu: '120000 (NG) / 96000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '36“ x 30 5/16" x 14 13/16"' 
  },
  { 
    sku: 'TH-RB-6', 
    burners: '6 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '30000 (NG) / 24000 (LP)', 
    total_btu: '180000 (NG) / 144000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '48" x 30 5/16" x 14 13/16"' 
  },
  { 
    sku: 'TH-RB-1B', 
    burners: '2 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '26500 (NG) / 22500 (LP)', 
    total_btu: '53000 (NG) / 45000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '18" x 21" x 17"', 
    features: "Heavy-duty cast iron burners for powerful and stable flame\nRugged stainless steel exterior designed for commercial kitchens\nIndependent manual controls for each burner\nRemovable burner grates for easy cleaning and service\nCompact countertop footprint with adjustable legs\nMultiple configurations available: 2, 4, or 6 burners\nCompatible with Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-RB-2B', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '26500 (NG) / 22500 (LP)', 
    total_btu: '106000 (NG) / 90000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '35 13/16" x 21" x 17"' 
  },
  { 
    sku: 'TH-RB-1', 
    burners: '2 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '40000 (NG) / 29500 (LP)', 
    total_btu: '80000 (NG) / 59000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '18" x 21" x 24 3/8"', 
    features: "Heavy-duty cast iron burners for powerful and stable flame\nRugged stainless steel exterior designed for commercial kitchens\nIndependent manual controls for each burner\nRemovable burner grates for easy cleaning and service\nCompact countertop footprint with adjustable legs\nMultiple configurations available: 2, 4 burners\nCompatible with Natural Gas or Liquid Propane" 
  },
  { 
    sku: 'TH-RB-2A', 
    burners: '4 Burners, Independent', 
    gas_type: 'NG/LP', 
    btu_per: '40000 (NG) / 29500 (LP)', 
    total_btu: '160000 (NG) / 118000 (LP)', 
    pressure: '5"w.c. (NG) / 10"w.c. (LP)', 
    regulator: '5"w.c. (NG) / 10"w.c. (LP)',
    unit_dim: '18" x 42" x 24 24 3/8"' 
  }
])

# Stainless Steel Food Service (Category Kind 'c')
root_ss = Category.create!(name: 'Stainless Steel Food Service', category_kind: 'c')
puts "Root category: Stainless Steel Food Service"

wt_features = "Constructed from Type 430 stainless steel, Reinforced tabletop with underside support, Smooth easy-to-clean surface, Rounded edges for safety, Adjustable bullet feet, Optional undershelf for storage, NSF Certified for commercial food service"

# C1. Work Tables
cat_work_tables = Category.create!(name: 'Work Tables', parent: root_ss, category_kind: 'c')

# C1.1 24" WIDE (Flat Top)
cat_wt_24_flat = Category.create!(name: '24" WIDE Work Tables', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_24_flat, [
  { sku: 'TH-MATS-2424E/P',  unit_dim: '24" x 24" x 34"', features: wt_features },
  { sku: 'TH-MATS-2430E/P',  unit_dim: '30" x 24" x 34"' },
  { sku: 'TH-MATS-2436E/P',  unit_dim: '36" x 24" x 34"' },
  { sku: 'TH-MATS-2448E/P',  unit_dim: '48" x 24" x 34"' },
  { sku: 'TH-MATS-2460E/P',  unit_dim: '60" x 24" x 34"' },
  { sku: 'TH-MATS-2472E/P',  unit_dim: '72" x 24" x 34"' },
  { sku: 'TH-MATS-2484E/P',  unit_dim: '84" x 24" x 34"' },
  { sku: 'TH-MATS-2496E/P',  unit_dim: '96" x 24" x 34"' }
])

# C1.2 30" WIDE (Flat Top)
cat_wt_30_flat = Category.create!(name: '30" WIDE Work Tables', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_30_flat, [
  { sku: 'TH-MATS-3024E/P',  unit_dim: '24" x 30" x 34"', features: wt_features },
  { sku: 'TH-MATS-3030E/P',  unit_dim: '30" x 30" x 34"' },
  { sku: 'TH-MATS-3036E/P',  unit_dim: '36" x 30" x 34"' },
  { sku: 'TH-MATS-3048E/P',  unit_dim: '48" x 30" x 34"' },
  { sku: 'TH-MATS-3060E/P',  unit_dim: '60" x 30" x 34"' },
  { sku: 'TH-MATS-3072E/P',  unit_dim: '72" x 30" x 34"' },
  { sku: 'TH-MATS-3084E/P',  unit_dim: '84" x 30" x 34"' },
  { sku: 'TH-MATS-3096E/P',  unit_dim: '96" x 30" x 34"' }
])

# C1.3 36" WIDE (Flat Top)
cat_wt_36_flat = Category.create!(name: '36" WIDE Work Tables', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_36_flat, [
  { sku: 'TH-MATS-3624E/P',  unit_dim: '24" x 36" x 34"', features: wt_features },
  { sku: 'TH-MATS-3630E/P',  unit_dim: '30" x 36" x 34"' },
  { sku: 'TH-MATS-3636E/P',  unit_dim: '36" x 36" x 34"' },
  { sku: 'TH-MATS-3648E/P',  unit_dim: '48" x 36" x 34"' },
  { sku: 'TH-MATS-3660E/P',  unit_dim: '60" x 36" x 34"' },
  { sku: 'TH-MATS-3672E/P',  unit_dim: '72" x 36" x 34"' },
  { sku: 'TH-MATS-3684E/P',  unit_dim: '84" x 36" x 34"' },
  { sku: 'TH-MATS-3696E/P',  unit_dim: '96" x 36" x 34"' }
])

wt_splash_features = "With 4\" Top Splash, E: Galvanized undershelf and legs, P: Stainless Steel undershelf and legs, Tables furnished with 6 legs on 84\"/96\" sizes, NSF Certified"

# C1.4 24" WIDE with Top Splash
cat_wt_24_splash = Category.create!(name: '24" WIDE Work Tables with Top Splash', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_24_splash, [
  { sku: 'TH-MATS-2424EA/PA', unit_dim: '24" x 24" x 34"+4"', features: wt_splash_features },
  { sku: 'TH-MATS-2430EA/PA', unit_dim: '30" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2436EA/PA', unit_dim: '36" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2448EA/PA', unit_dim: '48" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2460EA/PA', unit_dim: '60" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2472EA/PA', unit_dim: '72" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2484EA/PA', unit_dim: '84" x 24" x 34"+4"' },
  { sku: 'TH-MATS-2496EA/PA', unit_dim: '96" x 24" x 34"+4"' }
])

# C1.5 30" WIDE with Top Splash
cat_wt_30_splash = Category.create!(name: '30" WIDE Work Tables with Top Splash', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_30_splash, [
  { sku: 'TH-MATS-3024EA/PA', unit_dim: '24" x 30" x 34"+4"', features: wt_splash_features },
  { sku: 'TH-MATS-3030EA/PA', unit_dim: '30" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3036EA/PA', unit_dim: '36" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3048EA/PA', unit_dim: '48" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3060EA/PA', unit_dim: '60" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3072EA/PA', unit_dim: '72" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3084EA/PA', unit_dim: '84" x 30" x 34"+4"' },
  { sku: 'TH-MATS-3096EA/PA', unit_dim: '96" x 30" x 34"+4"' }
])

# C1.6 36" WIDE with Top Splash
cat_wt_36_splash = Category.create!(name: '36" WIDE Work Tables with Top Splash', parent: cat_work_tables, category_kind: 'c')
create_c_skus(cat_wt_36_splash, [
  { sku: 'TH-MATS-3624EA/PA', unit_dim: '24" x 36" x 34"+4"', features: wt_splash_features },
  { sku: 'TH-MATS-3630EA/PA', unit_dim: '30" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3636EA/PA', unit_dim: '36" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3648EA/PA', unit_dim: '48" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3660EA/PA', unit_dim: '60" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3672EA/PA', unit_dim: '72" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3684EA/PA', unit_dim: '84" x 36" x 34"+4"' },
  { sku: 'TH-MATS-3696EA/PA', unit_dim: '96" x 36" x 34"+4"' }
])

# C2. Sinks
cat_sinks = Category.create!(name: 'Sinks', parent: root_ss, category_kind: 'c')

# C2.1 Without Drainboard — 1 Tank
cat_sink_1t = Category.create!(name: '1 Tank Sinks without Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_1t, [
  { sku: 'TH1T1618', prod_dim: '22" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "1 Tank, Without drainboard" },
  { sku: 'TH1T1620', prod_dim: '22" x 25.8" x 44.5"',   bowl_dim: '16" x 20"' },
  { sku: 'TH1T1818', prod_dim: '24" x 23.8" x 44.5"',   bowl_dim: '18" x 18"' },
  { sku: 'TH1T2020', prod_dim: '26" x 25.8" x 44.5"',   bowl_dim: '20" x 20"' },
  { sku: 'TH1T1824', prod_dim: '24" x 29.8" x 44.5"',   bowl_dim: '18" x 24"' },
  { sku: 'TH1T2424', prod_dim: '24" x 29.8" x 44.5"',   bowl_dim: '24" x 24"' }
])

# C2.2 Without Drainboard — 2 Tanks
cat_sink_2t = Category.create!(name: '2 Tank Sinks without Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_2t, [
  { sku: 'TH2T1618', prod_dim: '38" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "2 Tanks, Without drainboard" },
  { sku: 'TH2T1620', prod_dim: '38" x 25.8" x 44.5"',   bowl_dim: '16" x 20"' },
  { sku: 'TH2T1818', prod_dim: '42" x 23.8" x 44.5"',   bowl_dim: '18" x 18"' },
  { sku: 'TH2T1824', prod_dim: '42" x 25.8" x 44.5"',   bowl_dim: '20" x 20"' },
  { sku: 'TH2T2020', prod_dim: '46" x 29.8" x 44.5"',   bowl_dim: '18" x 24"' },
  { sku: 'TH2T2424', prod_dim: '54" x 29.8" x 44.5"',   bowl_dim: '24" x 24"' }
])

# C2.3 Without Drainboard — 3 Tanks
cat_sink_3t = Category.create!(name: '3 Tank Sinks without Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_3t, [
  { sku: 'TH3T1618', prod_dim: '54" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "3 Tanks, Without drainboard" },
  { sku: 'TH3T1620', prod_dim: '54" x 25.8" x 44.5"',   bowl_dim: '16" x 20"' },
  { sku: 'TH3T1818', prod_dim: '60" x 23.8" x 44.5"',   bowl_dim: '18" x 18"' },
  { sku: 'TH3T2020', prod_dim: '60" x 25.8" x 44.5"',   bowl_dim: '20" x 20"' },
  { sku: 'TH3T1824', prod_dim: '60" x 29.8" x 44.5"',   bowl_dim: '18" x 24"' },
  { sku: 'TH3T2424', prod_dim: '78" x 29.8" x 44.5"',   bowl_dim: '24" x 24"' }
])

# C2.4 With One-Side Drainboard — 1 Tank
cat_sink_1t_1db = Category.create!(name: '1 Tank Sinks with One-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_1t_1db, [
  { sku: 'TH1T1618-L18', prod_dim: '37.2" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T1618-R18', prod_dim: '37.2" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T1618-L24', prod_dim: '43.2" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T1618-R24', prod_dim: '43.2" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "1 Tank, Right 24\" drainboard" },
  { sku: 'TH1T1620-L18', prod_dim: '37.2" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T1620-R18', prod_dim: '37.2" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T1620-L24', prod_dim: '43.2" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T1620-R24', prod_dim: '43.2" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "1 Tank, Right 24\" drainboard" },
  { sku: 'TH1T1818-L18', prod_dim: '39.2" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T1818-R18', prod_dim: '39.2" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T1818-L24', prod_dim: '45.2" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T1818-R24', prod_dim: '45.2" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "1 Tank, Right 24\" drainboard" },
  { sku: 'TH1T1824-L18', prod_dim: '39.2" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T1824-R18', prod_dim: '39.2" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T1824-L24', prod_dim: '45.2" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T1824-R24', prod_dim: '45.2" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "1 Tank, Right 24\" drainboard" },
  { sku: 'TH1T2020-L18', prod_dim: '41.2" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T2020-R18', prod_dim: '41.2" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T2020-L24', prod_dim: '47.2" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T2020-R24', prod_dim: '47.2" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "1 Tank, Right 24\" drainboard" },
  { sku: 'TH1T2424-L18', prod_dim: '45.2" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "1 Tank, Left 18\" drainboard" },
  { sku: 'TH1T2424-R18', prod_dim: '45.2" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "1 Tank, Right 18\" drainboard" },
  { sku: 'TH1T2424-L24', prod_dim: '51.2" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "1 Tank, Left 24\" drainboard" },
  { sku: 'TH1T2424-R24', prod_dim: '51.2" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "1 Tank, Right 24\" drainboard" }
])

# C2.5 With One-Side Drainboard — 2 Tanks
cat_sink_2t_1db = Category.create!(name: '2 Tank Sinks with One-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_2t_1db, [
  { sku: 'TH2T1618-L18', prod_dim: '53" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T1618-R18', prod_dim: '53" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T1618-L24', prod_dim: '59" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T1618-R24', prod_dim: '59" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "2 Tanks, Right 24\" drainboard" },
  { sku: 'TH2T1620-L18', prod_dim: '53" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T1620-R18', prod_dim: '53" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T1620-L24', prod_dim: '59" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T1620-R24', prod_dim: '59" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "2 Tanks, Right 24\" drainboard" },
  { sku: 'TH2T1818-L18', prod_dim: '57" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T1818-R18', prod_dim: '57" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T1818-L24', prod_dim: '63" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T1818-R24', prod_dim: '63" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "2 Tanks, Right 24\" drainboard" },
  { sku: 'TH2T2020-L18', prod_dim: '61" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T2020-R18', prod_dim: '61" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T2020-L24', prod_dim: '67" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T2020-R24', prod_dim: '67" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "2 Tanks, Right 24\" drainboard" },
  { sku: 'TH2T1824-L18', prod_dim: '57" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T1824-R18', prod_dim: '57" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T1824-L24', prod_dim: '63" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T1824-R24', prod_dim: '63" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "2 Tanks, Right 24\" drainboard" },
  { sku: 'TH2T2424-L18', prod_dim: '69" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "2 Tanks, Left 18\" drainboard" },
  { sku: 'TH2T2424-R18', prod_dim: '69" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "2 Tanks, Right 18\" drainboard" },
  { sku: 'TH2T2424-L24', prod_dim: '75" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "2 Tanks, Left 24\" drainboard" },
  { sku: 'TH2T2424-R24', prod_dim: '75" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "2 Tanks, Right 24\" drainboard" }
])

# C2.6 With One-Side Drainboard — 3 Tanks
cat_sink_3t_1db = Category.create!(name: '3 Tank Sinks with One-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_3t_1db, [
  { sku: 'TH3T1618-L18', prod_dim: '69" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T1618-R18', prod_dim: '69" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T1618-L24', prod_dim: '75" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T1618-R24', prod_dim: '75" x 23.8" x 44.5"',  bowl_dim: '16" x 18"', features: "3 Tanks, Right 24\" drainboard" },
  { sku: 'TH3T1620-L18', prod_dim: '69" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T1620-R18', prod_dim: '69" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T1620-L24', prod_dim: '75" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T1620-R24', prod_dim: '75" x 25.8" x 44.5"',  bowl_dim: '16" x 20"', features: "3 Tanks, Right 24\" drainboard" },
  { sku: 'TH3T1818-L18', prod_dim: '75" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T1818-R18', prod_dim: '75" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T1818-L24', prod_dim: '81" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T1818-R24', prod_dim: '81" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "3 Tanks, Right 24\" drainboard" },
  { sku: 'TH3T2020-L18', prod_dim: '81" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T2020-R18', prod_dim: '81" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T2020-L24', prod_dim: '87" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T2020-R24', prod_dim: '87" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "3 Tanks, Right 24\" drainboard" },
  { sku: 'TH3T1824-L18', prod_dim: '75" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T1824-R18', prod_dim: '75" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T1824-L24', prod_dim: '81" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T1824-R24', prod_dim: '81" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "3 Tanks, Right 24\" drainboard" },
  { sku: 'TH3T2424-L18', prod_dim: '93" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Left 18\" drainboard" },
  { sku: 'TH3T2424-R18', prod_dim: '93" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Right 18\" drainboard" },
  { sku: 'TH3T2424-L24', prod_dim: '99" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Left 24\" drainboard" },
  { sku: 'TH3T2424-R24', prod_dim: '99" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Right 24\" drainboard" }
])

# C2.7 With Both-Side Drainboard — 1 Tank
cat_sink_1t_2db = Category.create!(name: '1 Tank Sinks with Both-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_1t_2db, [
  { sku: 'TH1T1618-D18', prod_dim: '52" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T1618-D24', prod_dim: '64" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "1 Tank, Both-side 24\" drainboard" },
  { sku: 'TH1T1620-D18', prod_dim: '52" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T1620-D24', prod_dim: '64" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "1 Tank, Both-side 24\" drainboard" },
  { sku: 'TH1T1818-D18', prod_dim: '54" x 23.8" x 44.5"',   bowl_dim: '18" x 18"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T1818-D24', prod_dim: '66" x 23.8" x 44.5"',   bowl_dim: '18" x 18"', features: "1 Tank, Both-side 24\" drainboard" },
  { sku: 'TH1T1824-D18', prod_dim: '54" x 29.8" x 44.5"',   bowl_dim: '18" x 24"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T1824-D24', prod_dim: '66" x 29.8" x 44.5"',   bowl_dim: '18" x 24"', features: "1 Tank, Both-side 24\" drainboard" },
  { sku: 'TH1T2020-D18', prod_dim: '56" x 25.8" x 44.5"',   bowl_dim: '20" x 20"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T2020-D24', prod_dim: '68" x 25.8" x 44.5"',   bowl_dim: '20" x 20"', features: "1 Tank, Both-side 24\" drainboard" },
  { sku: 'TH1T2424-D18', prod_dim: '60" x 29.8" x 44.5"',   bowl_dim: '24" x 24"', features: "1 Tank, Both-side 18\" drainboard" },
  { sku: 'TH1T2424-D24', prod_dim: '72" x 29.8" x 44.5"',   bowl_dim: '24" x 24"', features: "1 Tank, Both-side 24\" drainboard" }
])

# C2.8 With Both-Side Drainboard — 2 Tanks
cat_sink_2t_2db = Category.create!(name: '2 Tank Sinks with Both-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_2t_2db, [
  { sku: 'TH2T1618-D18', prod_dim: '68" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T1618-D24', prod_dim: '80" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "2 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH2T1620-D18', prod_dim: '68" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T1620-D24', prod_dim: '80" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "2 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH2T1818-D18', prod_dim: '72" x 23.8" x 44.5"',   bowl_dim: '18" x 18"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T1818-D24', prod_dim: '84" x 23.8" x 44.5"',   bowl_dim: '18" x 18"', features: "2 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH2T1824-D18', prod_dim: '72" x 29.8" x 44.5"',   bowl_dim: '18" x 24"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T1824-D24', prod_dim: '84" x 29.8" x 44.5"',   bowl_dim: '18" x 24"', features: "2 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH2T2020-D18', prod_dim: '76" x 25.8" x 44.5"',   bowl_dim: '20" x 20"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T2020-D24', prod_dim: '88" x 25.8" x 44.5"',   bowl_dim: '20" x 20"', features: "2 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH2T2424-D18', prod_dim: '84" x 29.8" x 44.5"',   bowl_dim: '24" x 24"', features: "2 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH2T2424-D24', prod_dim: '96" x 29.8" x 44.5"',   bowl_dim: '24" x 24"', features: "2 Tanks, Both-side 24\" drainboard" }
])

# C2.9 With Both-Side Drainboard — 3 Tanks
cat_sink_3t_2db = Category.create!(name: '3 Tank Sinks with Both-Side Drainboard', parent: cat_sinks, category_kind: 'c')
create_c_skus(cat_sink_3t_2db, [
  { sku: 'TH3T1618-D18', prod_dim: '84" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T1618-D24', prod_dim: '96" x 23.8" x 44.5"',   bowl_dim: '16" x 18"', features: "3 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH3T1620-D18', prod_dim: '84" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T1620-D24', prod_dim: '96" x 25.8" x 44.5"',   bowl_dim: '16" x 20"', features: "3 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH3T1818-D18', prod_dim: '90" x 23.8" x 44.5"',   bowl_dim: '18" x 18"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T1818-D24', prod_dim: '102" x 23.8" x 44.5"',  bowl_dim: '18" x 18"', features: "3 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH3T1824-D18', prod_dim: '90" x 29.8" x 44.5"',   bowl_dim: '18" x 24"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T1824-D24', prod_dim: '102" x 29.8" x 44.5"',  bowl_dim: '18" x 24"', features: "3 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH3T2020-D18', prod_dim: '96" x 25.8" x 44.5"',   bowl_dim: '20" x 20"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T2020-D24', prod_dim: '108" x 25.8" x 44.5"',  bowl_dim: '20" x 20"', features: "3 Tanks, Both-side 24\" drainboard" },
  { sku: 'TH3T2424-D18', prod_dim: '108" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Both-side 18\" drainboard" },
  { sku: 'TH3T2424-D24', prod_dim: '120" x 29.8" x 44.5"',  bowl_dim: '24" x 24"', features: "3 Tanks, Both-side 24\" drainboard" }
])

# C3. Wall-mounted Sinks
cat_wall_sinks = Category.create!(name: 'Wall-mounted Sinks', parent: root_ss, category_kind: 'c')

# C3.1 Hand Sinks (Basic)
cat_hws_basic = Category.create!(name: 'Hand Sinks', parent: cat_wall_sinks, category_kind: 'c')
create_c_skus(cat_hws_basic, [
  { sku: 'TH-HWR12', unit_dim: '12" x 16" x 13"',   faucet: 'Includes', features: "Hand sink, Faucet and drain included" },
  { sku: 'TH-HWR15', unit_dim: '15.7" x 15" x 13"', faucet: 'Includes' },
  { sku: 'TH-HWR17', unit_dim: '17" x 15" x 13"',   faucet: 'Includes' }
])

# C3.2 Hand Sinks with Side Panels
cat_hws_side = Category.create!(name: 'Hand Sinks with Side Panels', parent: cat_wall_sinks, category_kind: 'c')
create_c_skus(cat_hws_side, [
  { sku: 'TH-HWR12W', unit_dim: '12" x 16" x 13"',   faucet: 'Includes', features: "Hand sink with side panels, Faucet and drain included" },
  { sku: 'TH-HWR15W', unit_dim: '15.7" x 15" x 13"', faucet: 'Includes' },
  { sku: 'TH-HWR17W', unit_dim: '17" x 15" x 13"',   faucet: 'Includes' }
])

# C3.3 Hand Sinks with Side Panels, Lower Panels & Knee Pedal
cat_hws_full = Category.create!(name: 'Hand Sinks with Side Panels, Lower Panels & Knee Pedal', parent: cat_wall_sinks, category_kind: 'c')
create_c_skus(cat_hws_full, [
  { sku: 'TH-HWR12W-XS', unit_dim: '12" x 16" x 13"',   faucet: 'Includes', features: "Hand sink with side panels, lower panels, and knee pedal, Faucet and drain included" },
  { sku: 'TH-HWR15W-XS', unit_dim: '15.7" x 15" x 13"', faucet: 'Includes' },
  { sku: 'TH-HWR17W-XS', unit_dim: '17" x 15" x 13"',   faucet: 'Includes' }
])

# C3.4 Hand Sinks with Lower Panels & Knee Pedal
cat_hws_lower = Category.create!(name: 'Hand Sinks with Lower Panels & Knee Pedal', parent: cat_wall_sinks, category_kind: 'c')
create_c_skus(cat_hws_lower, [
  { sku: 'TH-HWR12-XS', unit_dim: '12" x 16" x 13"',   faucet: 'Includes', features: "Hand sink with lower panels and knee pedal, Faucet and drain included" },
  { sku: 'TH-HWR15-XS', unit_dim: '15.7" x 15" x 13"', faucet: 'Includes' },
  { sku: 'TH-HWR17-XS', unit_dim: '17" x 15" x 13"',   faucet: 'Includes' }
])

puts "Seed data creation completed successfully."