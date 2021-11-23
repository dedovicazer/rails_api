class Api::V1::ResultsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :destroy]	
  before_action :get_survey
  
  def index
  	@results = @survey.results
    render json: @results, status: :ok
  end

  def create
    @result = Result.new(
      survey: @survey,
      result: result_params[:result].to_json,
    )

    if @result.save
      render json: @result, status: :created
    else
      render json: @result.errors, status: :unprocessable_entity  
    end
  end

  # def create
  #   @result = Result.new(result: JSON.parse(request.body.read))
  #   @result.survey = @survey

  #   if @result.save
  #     render json: @result, status: :created
  #   else
  #     render json: @result.errors, status: :unprocessable_entity
  #   end
  # end

  def destroy
    @result = Result.find(params[:id])
    @result.destroy
  end

  private
    def get_survey
      @survey = Survey.find(params[:survey_id])
    end

    def result_params
      # define what could be questions  
      params.permit(:result => [:questionId, :type, :answer, :selectedOption => [:key, :value]])
    end
end
