# frozen_string_literal: true

json.array! @reminders, partial: "reminders/reminder", as: :reminder
