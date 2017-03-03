base = [0.2, 0.2, 0.2, 0.2, 0.2]
now = [1.0, nil, nil, nil, nil]

adjusted = base.map.with_index do |item, index|
  if now[index].nil?
    item
  else
    item * 0.75 + now[index] * 0.25
  end
end

p adjusted # [0.4, 0.2, 0.2, 0.2, 0.2]

normalized = adjusted.map { |el| el/adjusted.reduce(:+).to_f }

p normalized
