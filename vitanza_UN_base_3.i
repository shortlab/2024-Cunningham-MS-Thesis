[GlobalParams]
  density = 13630.0
  order = SECOND
  family = LAGRANGE
  energy_per_fission = 3.20435313e-11
  value_range_behavior = IGNORE
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
[]

[Mesh]
  coord_type = RZ
  patch_size = 10
  patch_update_strategy = auto
  [mesh]
    type = FileMeshGenerator
    file = 27_1_mesh.e
  []
[]

[Variables]
  [temp]
    initial_condition = 293.0
  []
[]

[AuxVariables]
  [grain_radius]
    block = 3
    initial_condition = 1.7e-5
  []
  [dislocation_density]
    initial_condition = 3e13
  []
[]

[Functions]
  [power_profile]
    type = PiecewiseLinear
    x = '0 100'
    y = '0 8100'
  []
  [axial_peaking_factors]
    type = ParsedFunction
    expression = 1
  []
  [q]
    type = CompositeFunction
    functions = 'power_profile axial_peaking_factors'
  []
[]

[Kernels]
  [heat]
    type = HeatConduction
    variable = temp
    extra_vector_tags = 'ref'
  []
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
    density_name = 1
    extra_vector_tags = 'ref'
  []
  [heat_source]
    type = NeutronHeatSource
    variable = temp
    block = 3
    burnup_function = burnup
    extra_vector_tags = 'ref'
  []
[]

[Burnup]
  [burnup]
    block = 3
    rod_ave_lin_pow = power_profile
    axial_power_profile = axial_peaking_factors
    num_radial = 80
    num_axial = 20
    a_upper = 0.01496
    a_lower = 0.00226
    fuel_inner_radius = 0.0
    fuel_outer_radius = 0.00291
    fuel_volume_ratio = 1
    RPF = RPF
  []
[]

[AuxKernels]
  [GrainRadiusAux]
    block = 3
    execute_on = linear
    temperature = temp
    type = GrainRadiusAux
    variable = grain_radius
  []
[]

[BCs]
  [fuel_wall_temp]
    type = DirichletBC
    variable = temp
    boundary = '10'
    value = 1215
    preset = false
  []
[]

[Materials]
  [vacancy_GB_diffusion]
    type = ParsedMaterial
    block = '3'
    property_name = vacancy_GB_diffusion
    coupled_variables = 'temp'
    expression = 'kBT := 1.380649e-23 / 1.602176634e-19 * temp;
                  1 * 1.14E-03 * exp(-1.0 * 5.96 / kBT) * 1e6'
  []

  [fuel_thermal]
    type = MNThermal
    block = 3
    temperature = temp
    burnup = burnup
    formulation = HAYES
    porosity = 0.13
    outputs = all
  []
  [fuel_density]
    type = PorosityDensity
    block = 3
    theoretical_density = 87
    porosity = 0.87    
    outputs = all
  []
  [fission_gas_behavior]
    type = UNSifgrs
    block = 3
    temperature = temp
    vacancy_GB_diffusivity = vacancy_GB_diffusion
    outputs = all
    fission_rate = fission_rate
    ig_bubble_coarsening = WITH_COARSENING
    dislocation_density = dislocation_density
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       superlu_dist'
  line_search = 'none'

  l_max_its = 50
  l_tol = 8e-3

  nl_max_its = 15
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-10

  start_time = -100
  dtmax = 1e6
  dtmin = 1
  end_time = 2e9

  [Quadrature]
    order = fifth
    side_order = seventh
  []

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 10
    optimal_iterations = 6
  []
[]

[Postprocessors]
  [ave_temp_interior]
    type = SideAverageValue
    boundary = 9
    variable = temp
    execute_on = 'initial linear'
  []
  [pellet_volume]
    type = InternalVolume
    boundary = 8
    execute_on = 'initial timestep_end'
  []
  [max_fuel_temp]
    type = NodalExtremeValue
    block = 3
    value_type = max
    variable = temp
    execute_on = 'initial timestep_end'
  []
  [min_fuel_temp]
    type = NodalExtremeValue
    block = 3
    value_type = min
    variable = temp
    execute_on = 'initial timestep_end'
  []
  [density]
    type = ElementAverageMaterialProperty
    mat_prop = 'density'
    block = 3
    execute_on = 'initial timestep_end'
  []
  [fis_gas_generated]
    type = ElementIntegralFisGasGeneratedSifgrs
    block = '3'
  []
  [fis_gas_released]
    type = ElementIntegralFisGasReleasedSifgrs
    block = '3'
  []
  [fis_gas_grain]
    type = ElementIntegralFisGasGrainSifgrs
    block = '3'
  []
  [fis_gas_boundary]
    type = ElementIntegralFisGasBoundarySifgrs
    block = '3'
  []
  [gas_volume]
    type = InternalVolume
    boundary = 9
    execute_on = 'initial linear'
  []
  [flux_from_fuel]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 10
    diffusivity = thermal_conductivity
  []
  [rod_total_power]
    block = 3
    execute_on = linear
    burnup_function = burnup
    type = ElementIntegralPower
    variable = temp
  []
  [rod_input_power]
    type = FunctionValuePostprocessor
    function = power_profile
    scale_factor = 0.0127
  []
  [ave_fission_rate]
    type = ElementAverageValue
    block = 3
    variable = fission_rate
  []
  [average_burnup]
    type = RodAverageBurnup
    burnup_function = burnup
  []
  [thermal_conductivity]
    type = ElementAverageMaterialProperty
    mat_prop = thermal_conductivity
    block = 3
    execute_on = 'initial timestep_end'
  []
  [specific_heat]
    type = ElementAverageMaterialProperty
    mat_prop = specific_heat
    block = 3
    execute_on = 'initial timestep_end'
  []
  [fuel_center_temperature]
    type = NodalVariableValue
    nodeid = 174 # Paraview GlobalNodeID 175 at (0.0, 0.00862374)
    variable = temp
    execute_on = 'initial timestep_end'
  []
  [fis_gas_percent]
    type = FGRPercent
    fission_gas_released = fis_gas_released
    fission_gas_generated = fis_gas_generated
  []
[]

[PerformanceMetricOutputs]
[]

[Outputs]
  perf_graph = true
  exodus = false
  color = false
  print_linear_residuals = true
  [csv]
    type = CSV
    execute_on = final
  []
  [chkfile]
    type = CSV
    show = 'burnup fis_gas_percent fuel_center_temperature rod_total_power pellet_volume'
    execute_on = final
  []
[]

[UserObjects]
  [terminator]
    type = Terminator
    expression = 'fis_gas_percent >= 0.01'
  []
[]
