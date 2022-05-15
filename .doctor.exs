%Doctor.Config{
  exception_moduledoc_required: true,
  failed: false,
  ignore_modules: [Exzeitable],
  ignore_paths: [~r|lib/test_web|, ~r|test/support|],
  min_module_doc_coverage: 100,
  min_module_spec_coverage: 100,
  min_overall_doc_coverage: 100,
  min_overall_spec_coverage: 100,
  moduledoc_required: true,
  raise: false,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: false,
  umbrella: false
}
