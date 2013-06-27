class Api::QuestionsController < ApplicationController

  def index
    questions = Question.where(track_id: params[:id])

    if questions.present?
      render json: questions
    else
      render_unavailable
    end
  end

  def create
    question = Question.create(params[:question].merge(track_id: params[:id]))

    if question.valid?
      client = Faye::Client.new('http://localhost:9292/faye')
      client.publish("/tracks/#{params[:id]}", 'text' => question)
      render json: question, status: 201
    else
      render_create_error(question)
    end
  end

  def vote
    question = Question.find(params[:id])

    if question
      vote = Vote.find_by_user_id_and_question_id(params[:user_id], question.id)
      if vote
        nil
      else
        Vote.create(user_id: params[:user_id], question_id: question.id)
        question.increment_vote
      end
    else
      nil
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
