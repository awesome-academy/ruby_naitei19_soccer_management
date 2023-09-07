class Admin::FootballPitchesController < Admin::BaseController
  # callback
  before_action :find_football_pitch_base_id, only: %i(show edit update destroy)

  def index
    @list_football_pitches = FootballPitch.all
  end

  def show
    return if @football_pitch

    redirect_to admin_football_pitches_path
  end

  def new
    @football_pitch = FootballPitch.new
  end

  def create
    if FootballPitch.create!(football_pitch_params)
      flash[:success] = t "football_pitches.create.success"
      redirect_to admin_football_pitches_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @football_pitch.update football_pitch_params
      flash[:success] = t "football_pitches.create.success"
      redirect_to admin_football_pitch_path @football_pitch
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    values_to_check = [:approve, :cancelled, :expired]

    is_valid = values_to_check.all? do |value|
      @football_pitch.bookings.booking_statuses[value].present?
    end

    if is_valid && @football_pitch.destroy
      flash[:success] = t("football_pitches.delete.success").capitalize
    else
      flash[:danger] = t("football_pitches.delete.failed").capitalize
    end
    redirect_to admin_football_pitches_path, status: :see_other
  end

  private

  def football_pitch_params
    params.require(:football_pitch).permit(:name, :location, :length, :width,
                                           :capacity, :price, :description,
                                           :football_pitch_types, images: [])
  end

  def find_football_pitch_base_id
    @football_pitch = FootballPitch.find_by id: params[:id]
  end
end
