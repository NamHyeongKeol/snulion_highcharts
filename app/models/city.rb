class City < ApplicationRecord
  def self.sorting_all(sorting_params)
    cities = City.all
    sorting_params.permit! # 이건 뭔지 몰라도 됨
    sorting_params = sorting_params.to_h
    sorting_params.each do |p|
      cities = cities.order("#{p.last[:arg]} #{p.last[:order]}")
    end
    return cities
  end

  def self.charting_all(charting_params)
    data = {
      title: "#{charting_params[:x]}에 대한 #{charting_params[:y]}",
      subtitle: "Column Chart",
      yAxis: "#{charting_params[:y]}",
      series: [{
        name: "#{charting_params[:x]}",
        colorByPoint: true,
        data: making_data(charting_params) # [["아시아", 8246.82926829268], ["북아메리카", 6788.5], ... ]
      }]
    }
    return data
  end

  private
    def self.making_data(charting_params)
      if (charting_params[:y].eql?("density"))
        return City.group(charting_params[:x]).average(:density).map{|x| [x.first, x.last.to_f]}.sort_by(&:last).reverse
      else
        return City.group(charting_params[:x]).sum(charting_params[:y]).to_a.sort_by(&:last).reverse
      end
    end
end
