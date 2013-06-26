class Api::QuestionsController < ApplicationController

  def index
    render json: Question.all
  end

  def show
    questions = Question.where(track_id: params[:track_id])

    if questions.present?
      render json: questions
    else
      render_unavailable
    end
  end

  def create
    question = Question.create(params[:question])

    if question.valid?
      client = Faye::Client.new('http://localhost:9292/faye')
      client.publish("/tracks/#{params[:question][:track_id]}", 'text' => question)
      render json: question, status: 201
    else
      render_create_error(question)
    end
  end

  private

  def render_unavailable
    render json: {error: "No track found"}, status: 404
  end

  def render_create_error(question)
    render json: {error: question.errors}, status: 400
  end

end
