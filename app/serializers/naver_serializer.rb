class NaverSerializer
  include JSONAPI::Serializer
  attributes :name, :birthdate, :admission_date, :job_role
end