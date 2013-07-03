class Api::QuestionsController < ApplicationController

  def index
    questions = Question.where(track_id: params[:track_id])
    render json: questions
  end

  def create
    question = Question.create(params[:question].merge(track_id: params[:track_id]))

    if question.valid?
      client = Faye::Client.new('http://localhost:9292/faye')
      client.publish("/tracks/#{params[:track_id]}/questions", 'text' => question)
      render json: question, status: 201
    else
      render_create_error(question)
    end
  end

  def vote
    question = Question.find(params[:id])
    if vote = Vote.add_for_user_question(params[:vote][:user_id], question)
      client = Faye::Client.new('http://localhost:9292/faye')

      client.publish("/tracks/#{params[:track_id]}/questions/vote", 'text' => question)
    end
  end

  private


  def render_create_error(question)
    render json: {error: question.errors}, status: 400
  end

end
