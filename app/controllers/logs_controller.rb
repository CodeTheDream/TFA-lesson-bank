class LogsController < ApplicationController
  def index
    @logs = Log.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @logs.to_csv }
      format.xls #{ send_data @logs.to_csv(col_sep: "\t") }
    end
  end 
end
