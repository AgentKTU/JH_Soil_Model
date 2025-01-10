# 2phase heat conduction, with saturation fixed at 0.5
# apply a boundary condition of T=300 to a bar that
# is initially at T=200, and observe the expected
# error-function response
[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = ../models/Soil_Model.msh

#   type = GeneratedMeshGenerator
#   dim = 2
#   nx = 10
#   ny = 10
#   xmin = 0
#   xmax = 100
#   ymin = 0
#   ymax = 20
#  []
#  [center_node]
#    type = BoundingBoxNodeSetGenerator
#    input = mesh
#    new_boundary = 'source'
#    top_right = '50.5 10.5 0'
#    bottom_left = '49.5 9.5 0'
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 -9.8065 0'
[]

[Variables]
  [phase0_porepressure]
    initial_condition = 0
  []
  [phase1_saturation]
    initial_condition = 0.5
  []
  [temp]
    initial_condition = 293
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
  []
  [heat_conduction]
    type = PorousFlowHeatConduction
    variable = temp
  []
  [heat_advection]
    type = PorousFlowHeatAdvection
    variable = temp
  []
  [adv0]
    type = PorousFlowAdvectiveFlux
    variable = phase0_porepressure
    fluid_component = 0
  []
  [adv1]
    type = PorousFlowAdvectiveFlux
    variable = phase1_saturation
    fluid_component = 1
  []
  [pressure0_dt]
     type = PorousFlowMassTimeDerivative
     variable = phase0_porepressure
     fluid_component = 0
    []
  [pressure1_dt]
     type = PorousFlowMassTimeDerivative
     variable = phase1_saturation
     fluid_component = 1
  []
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
    density0 = 0.3
    thermal_expansion = 0
    cv = 2
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temp
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '0.3 0 0  0 0.3 0  0 0 0.3'
    wet_thermal_conductivity = '1.7 0 0  0 1.7 0  0 0 1.7'
    exponent = 1.0
    aqueous_phase_number = 0
  []
  [perm]
    type = PorousFlowPermeabilityConst
    permeability = '1e-10 0 0 0 1e-10 0 0 0 1e-10'
  []
  [relperm_0]
    type = PorousFlowRelativePermeabilityVG
    m = 0.22
    phase = 0

  []
  [relperm_1]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 1
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
  []
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 0.4
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 1000
    density = 2600
  []
  [mass_frac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'x0 x1'
  []
  [simple_fluid0]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid0
    phase = 0
  []
  [simple_fluid1]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid1
    phase = 1
  []
[]

[BCs]
  [sorce]
    type = DirichletBC
    value = 363.15
    variable = temp
    boundary = 'conductor'
  []
  [flow_out_T]
    type = PorousFlowOutflowBC
    variable = temp
    flux_type = heat
    boundary = 'left right top bottom'
  []
  [atm_P]
    type = DirichletBC
    boundary = 'top'
    value = 0
    variable = phase0_porepressure
  []
  [atm_T]
    type = DirichletBC
    boundary = 'top'
    value = 293.15
    variable = temp
  []
  [p_out]
    type = PorousFlowOutflowBC
    variable = phase0_porepressure
    flux_type = fluid
    boundary = 'left right top bottom'
  []
[]


[Preconditioning]
  active=basic
  [andy]
    type = SMP
    full = true
  []
  [basic]
    type = SMP
    full = true
  #  petsc_options = '-snes_lag_jacobian -snes_lag_jacobian_persists'
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0
  end_time = 1e7
  nl_rel_tol = 1e-4

  [TimeSteppers]
   [iterative]
    type = IterationAdaptiveDT
    dt = 5
    growth_factor = 2
  []
 []
[]

[Outputs]
  print_linear_residuals = true
  print_nonlinear_residuals = true
  perf_graph = true
  file_base = two_phase
  [csv]
    type = CSV
  []
  exodus = true
[]
