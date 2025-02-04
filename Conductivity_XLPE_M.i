# @Konstantin changes this value to set the temperatre at the source (this is in grad)
# this will also names the output file accordingly
Tvalue = 90

[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = 'mesh/cableinsoil.msh'
  []
  [add_source]
    type = ExtraNodesetGenerator
    input = mesh
    coord = '1.5 2.2 0.0'
    new_boundary = 'source'
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 -9.8065 0'
[]

[Variables]
  [phase0_porepressure]
    initial_condition = 0.0
    block = 'Soil Air PE'
  []
  [phase1_saturation]
    initial_condition = 0.5
    block = 'Soil Air PE'
  []
  [temp]
    initial_condition = 293.15 # 20�C in K
  []
[]
[AuxVariables]
  [x0]
    initial_condition = 0.99
  []
  [x1]
    initial_condition = 0.01
  []
[]

[Kernels]
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = temp
    block = 'Soil Air PE'
  []
  [heat_conduction]
    type = PorousFlowHeatConduction
    variable = temp
    block = 'Soil Air PE'
  []
  [heat_advection]
    type = PorousFlowHeatAdvection
    variable = temp
    block = 'Soil Air PE'
  []
  [adv0]
    type = PorousFlowAdvectiveFlux
    variable = phase0_porepressure
    fluid_component = 0
    block = 'Soil Air PE'
  []
  [adv1]
    type = PorousFlowAdvectiveFlux
    variable = phase1_saturation
    fluid_component = 1
    block = 'Soil Air PE'
  []
  [pressure0_dt]
    type = PorousFlowMassTimeDerivative
    variable = phase0_porepressure
    fluid_component = 0
    block = 'Soil Air PE'
  []
  [pressure1_dt]
    type = PorousFlowMassTimeDerivative
    variable = phase1_saturation
    fluid_component = 1
    block = 'Soil Air PE'
  []
  [heat_trans_cable]
    type = HeatConduction
    variable = temp
    block = 'Copper XLPE'
  []
  [HeatTdot]
    type = HeatConductionTimeDerivative
    variable = temp
    block = 'Copper XLPE'
  []
  #  [heat_cable]
  #    type = HeatSource
  #    variable = temp
  #    value = 3300
  #    block = source
  #  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'temp phase0_porepressure phase1_saturation'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc]
    type = PorousFlowCapillaryPressureConst
    pc = 1e4
  []
[]

[FluidProperties]
  [simple_fluid0]
    type = SimpleFluidProperties
    density0 = 1000
    thermal_expansion = 0
    cv = 1
  []
  [simple_fluid1]
    type = SimpleFluidProperties
    density0 = 0.6
    thermal_expansion = 0
    cv = 2
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temp
    block = 'Soil Air PE'
  []
  [soil_thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '0.47 0 0  0 0.47 0  0 0 0.47'
    wet_thermal_conductivity = '2.2 0 0  0 2.2 0  0 0 2.2'
    exponent = 1.0
    aqueous_phase_number = 0
    block = 'Soil Air PE'
  []
  [perm]
    type = PorousFlowPermeabilityConst
    permeability = '1e-10 0 0 0 1e-10 0 0 0 1e-10'
    block = 'Soil Air PE'
  []
  [relperm_0]
    type = PorousFlowRelativePermeabilityVG
    m = 0.22
    phase = 0
    block = 'Soil Air PE'
  []
  [relperm_1]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 1
    block = 'Soil Air PE'
    # []
    #  [relperm_0]
    #   type = PorousFlowRelativePermeabilityCorey
    #   n = 2
    #   phase = 0
    #   s_res = 0.1
    #   sum_s_res = 0.11
    # []
    # [relperm_1]
    #   type = PorousFlowRelativePermeabilityCorey
    #   n = 2
    #   phase = 1
    #   s_res = 0.1
    #   sum_s_res = 0.11
  []
  [ppss]
    type = PorousFlow2PhasePS
    phase0_porepressure = phase0_porepressure
    phase1_saturation = phase1_saturation
    capillary_pressure = pc
    block = 'Soil Air PE'
  []
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 0.4
    block = 'Soil Air PE'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 1000
    density = 2660
    block = 'Soil Air PE'
  []
  [mass_frac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'x0 x1'
    block = 'Soil Air PE'
  []
  [simple_fluid0]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid0
    phase = 0
    block = 'Soil Air PE'
  []
  [simple_fluid1]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid1
    phase = 1
    block = 'Soil Air PE'
  []
  [k_copper]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '397.48' #copper in W/(m K)
    block = 'Copper'
  []
  [cp_copper]
    type = GenericConstantMaterial
    prop_names = 'specific_heat'
    prop_values = '385.0' #copper in J/(kg K)
    block = 'Copper'
  []
  [rho_copper]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '8920.0' #copper in kg/(m^3)
    block = 'Copper'
  []
  [k_xlpe]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '0.33' #copper in W/(m K)
    block = ' XLPE'
  []
  [cp_xlpe]
    type = GenericConstantMaterial
    prop_names = 'specific_heat'
    prop_values = '3000' #copper in J/(kg K)
    block = 'XLPE'
  []
  [rho_xlpe]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '950' #copper in kg/(m^3)
    block = 'XLPE'
  []
[]

[BCs]
  [sorce]
    type = FunctionDirichletBC
    function = T_source
    variable = temp
    boundary = 'source'
  []
  #  [flow_out_T]
  #   type = PorousFlowOutflowBC
  #    variable = temp
  #    flux_type = heat
  #    boundary = 'left right bottom'
  #  []
  [atm_P]
    type = DirichletBC
    boundary = 'top'
    value = 0.0
    variable = phase0_porepressure
  []
  [base_P]
    type = DirichletBC
    boundary = 'bottom'
    value = 16.5 # this is the value from the initial set up
    variable = phase0_porepressure
  []
  [atm_T]
    type = DirichletBC
    boundary = 'top'
    value = 278.15 # 5 °C
    variable = temp
  []
  [base_T]
    type = DirichletBC
    value = 293.15
    boundary = 'bottom'
    variable = temp
  []
  #  [p_out]
  #    type = PorousFlowOutflowBC
  #    variable = phase0_porepressure
  #    flux_type = fluid
  #    boundary = 'left right bottom'
  #  []
[]

[Preconditioning]
  active = 'SMP'
  [andy]
    type = SMP
    full = true
  []
  [basic]
    type = SMP
    full = false
    #  petsc_options = '-snes_lag_jacobian -snes_lag_jacobian_persists'
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
  [SMP]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package
                           -snes_atol -snes_rtol -snes_max_it
                           -ksp_rtol -ksp_max_it'
    petsc_options_value = 'lu  mumps
                           1e-6 1e-10 10
                           1e-10 100'
  []
  [FSP]
    type = FSP
    topsplit = 'pT'
    [pT]
      splitting = 'p T'
      splitting_type = MULTIPLICATIVE
      petsc_options_iname = '-ksp_type
                             -ksp_rtol -ksp_max_it
                             -snes_type -snes_linesearch_type
                             -snes_atol -snes_stol -snes_rtol -snes_max_it'
      petsc_options_value = 'fgmres
                             1e-12 50
                             newtonls basic
                             1e-6 0 1e-10 10'
    []
    [p]
      vars = 'phase0_porepressure phase1_saturation'
      petsc_options_iname = '-pc_type -pc_factor_mat_solver_type
                           -ksp_rtol -ksp_max_it'
      petsc_options_value = 'lu  mumps
                             1e-4 100'
    []
    [T]
      vars = 'temp'
      petsc_options_iname = '-pc_type -pc_factor_mat_solver_type
                           -ksp_rtol -ksp_max_it'
      petsc_options_value = 'lu  mumps
                             1e-4 100'
    []
  []
[]

[Functions]
  [T_source]
    type = ParsedFunction
    expression = 'TV+273.15'
    symbol_names = 'TV'
    symbol_values = '${Tvalue}'
  []
  [dt_evol]
    type = ParsedFunction
    expression = 'if(t<t0,dt0,if(t>t0&t<t1,dt1,dt2))'
    symbol_names = 't0 t1 dt0 dt1 dt2'
    symbol_values = '10000 100000 1000 10000 80000'
  []
  [dt_evol_better]
    type = ParsedFunction
    expression = 'if(t<t0,dt0,if(t>t0&t<t1,dt1,dt2))'
    symbol_names = 't0 t1 dt0 dt1 dt2'
    symbol_values = '8640 86400 864 8640 86400'
  []
[]

[Executioner]
  type = Transient
  automatic_scaling = true
  compute_scaling_once = false
  solve_type = NEWTON
  start_time = 0
  end_time = 31536000 # second per year
  #dtmax = 3000 #86400 # 1 day
  #dtmax = 600
  line_search = BASIC
  [TimeSteppers]
    # [iterative]
    #   type = IterationAdaptiveDT
    #   dt = 500
    #   growth_factor = 1.5
    # []
    [function_dt]
      type = FunctionDT
      function = dt_evol_better
    []
  []
[]

[Outputs]
  print_linear_residuals = false
  print_nonlinear_residuals = true
  perf_graph = true
  file_base = Conductivity_XLPE_${Tvalue}
  [csv]
    type = CSV
  []
  exodus = true
[]

# [Debug]
#   show_var_residual = 'phase0_porepressure phase1_saturation temp'
#   show_var_residual_norms = true
# []
