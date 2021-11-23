class Api::V1::SurveysController < ApplicationController
  before_action :authenticate_with_token!
  before_action :get_user, only: [:create, :destroy, :index]
  before_action :get_survey, only: [:show, :update, :destroy]

  def index
  	@surveys = @user.surveys

  	render json: @surveys
  end

  def show
  	render json: @survey
  end

  def create
  	@survey = Survey.new(
  	  user: @user,
  	  title: survey_params[:title],
  	  description: survey_params[:description],
  	  questions: survey_params[:questions].to_json,
  	)

  	if @survey.save
  	  render json: @survey, status: :created
  	else
  	  render json: @survey.errors, status: :unprocessable_entity	
  	end
  end

  def update
  	@survey.title = survey_params[:title] if !survey_params[:title].nil?
  	@survey.description = survey_params[:description] if !survey_params[:description].nil?
  	@survey.questions = survey_params[:questions].to_json if !survey_params[:questions].nil?

  	if @survey.save
  	  render json: @survey, status: :ok
  	else
  	  render json: @survey.errors, status: :unprocessable_entity	
  	end
  end

  def destroy
  	@survey.destroy
  end

  private

    def get_survey
      @survey = Survey.find(params[:id])	
    end

    def get_user
      @user = User.find(params[:user_id])	
    end

    def survey_params
      # define what could be questions	
      params.permit(:title, :description, :questions => [:questionId, :type, :questionText, :options => [:key, :value]])
    end
end