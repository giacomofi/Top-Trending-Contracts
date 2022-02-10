['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-24\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '// Copyright (c) 2021 0xdev0 - All rights reserved\n', '// https://twitter.com/0xdev0\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '  function initialize() external;\n', '  function totalSupply() external view returns (uint);\n', '  function balanceOf(address account) external view returns (uint);\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint);\n', '  function symbol() external view returns (string memory);\n', '  function decimals() external view returns (uint);\n', '  function approve(address spender, uint amount) external returns (bool);\n', '  function mint(address account, uint amount) external;\n', '  function burn(address account, uint amount) external;\n', '  function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'interface ILendingPair {\n', '  function checkAccountHealth(address _account) external view;\n', '  function totalDebt(address _token) external view returns(uint);\n', '  function lpToken(address _token) external view returns(IERC20);\n', '  function debtOf(address _account, address _token) external view returns(uint);\n', '  function deposit(address _token, uint _amount) external;\n', '  function withdraw(address _token, uint _amount) external;\n', '  function borrow(address _token, uint _amount) external;\n', '  function repay(address _token, uint _amount) external;\n', '  function withdrawRepay(address _token, uint _amount) external;\n', '  function withdrawBorrow(address _token, uint _amount) external;\n', '  function controller() external view returns(IController);\n', '\n', '  function swapTokenToToken(\n', '    address  _fromToken,\n', '    address  _toToken,\n', '    address  _recipient,\n', '    uint     _inputAmount,\n', '    uint     _minOutput,\n', '    uint     _deadline\n', '  ) external returns(uint);\n', '}\n', '\n', 'interface IInterestRateModel {\n', '  function systemRate(ILendingPair _pair) external view returns(uint);\n', '  function supplyRate(ILendingPair _pair, address _token) external view returns(uint);\n', '  function borrowRate(ILendingPair _pair, address _token) external view returns(uint);\n', '}\n', '\n', 'interface IController {\n', '  function interestRateModel() external view returns(IInterestRateModel);\n', '  function feeRecipient() external view returns(address);\n', '  function priceDelay() external view returns(uint);\n', '  function slowPricePeriod() external view returns(uint);\n', '  function slowPriceRange() external view returns(uint);\n', '  function liqMinHealth() external view returns(uint);\n', '  function liqFeePool() external view returns(uint);\n', '  function liqFeeSystem() external view returns(uint);\n', '  function liqFeeCaller() external view returns(uint);\n', '  function liqFeesTotal() external view returns(uint);\n', '  function depositLimit(address _lendingPair, address _token) external view returns(uint);\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() {\n', '    owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), owner);\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns (bool) {\n', '    return msg.sender == owner;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(owner, address(0));\n', '    owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Controller is Ownable {\n', '\n', '  IInterestRateModel public interestRateModel;\n', '\n', '  uint public priceDelay;\n', '  uint public slowPricePeriod;\n', '  uint public slowPriceRange; // 1e18 - 1% during first slowPricePeriod, 99% during remaining (priceDelay - slowPricePeriod)\n', '\n', '  uint public liqMinHealth; // 15e17 = 1.5\n', '  uint public liqFeePool;   // 45e17 = 4.5%\n', '  uint public liqFeeSystem; // 45e17 = 4.5%\n', '  uint public liqFeeCaller; // 1e18  = 1%\n', '\n', '  mapping(address => mapping(address => uint)) public depositLimit;\n', '\n', '  address public feeRecipient;\n', '\n', '  constructor(\n', '    IInterestRateModel _interestRateModel,\n', '    uint _priceDelay,\n', '    uint _slowPricePeriod,\n', '    uint _slowPriceRange,\n', '    uint _liqMinHealth,\n', '    uint _liqFeePool,\n', '    uint _liqFeeSystem,\n', '    uint _liqFeeCaller\n', '  ) {\n', '    priceDelay = _priceDelay;\n', '    slowPricePeriod = _slowPricePeriod;\n', '    slowPriceRange = _slowPriceRange;\n', '    feeRecipient = msg.sender;\n', '    interestRateModel = _interestRateModel;\n', '\n', '    setLiqParams(_liqMinHealth,  _liqFeePool, _liqFeeSystem, _liqFeeCaller);\n', '  }\n', '\n', '  function setFeeRecipient(address _feeRecipient) public onlyOwner {\n', "    require(_feeRecipient != address(0), 'PairFactory: _feeRecipient != 0x0');\n", '    feeRecipient = _feeRecipient;\n', '  }\n', '\n', '  function setLiqParams(\n', '    uint _liqMinHealth,\n', '    uint _liqFeePool,\n', '    uint _liqFeeSystem,\n', '    uint _liqFeeCaller\n', '  ) public onlyOwner {\n', '    // Never more than a total of 20%\n', '    require(_liqFeePool + _liqFeeSystem + _liqFeeCaller <= 20e18, "PairFactory: fees too high");\n', '\n', '    liqMinHealth = _liqMinHealth;\n', '    liqFeePool = _liqFeePool;\n', '    liqFeeSystem = _liqFeeSystem;\n', '    liqFeeCaller = _liqFeeCaller;\n', '  }\n', '\n', '  function setPriceDelay(uint _value) onlyOwner public {\n', '    priceDelay = _value;\n', '  }\n', '\n', '  function setSlowPricePeriod(uint _value) onlyOwner public {\n', '    slowPricePeriod = _value;\n', '  }\n', '\n', '  function setSlowPriceRange(uint _value) onlyOwner public {\n', '    slowPriceRange = _value;\n', '  }\n', '\n', '  function setInterestRateModel(IInterestRateModel _value) onlyOwner public {\n', '    interestRateModel = _value;\n', '  }\n', '\n', '  function setDepositLimit(address _pair, address _token, uint _value) public onlyOwner {\n', '    depositLimit[_pair][_token] = _value;\n', '  }\n', '\n', '  function liqFeesTotal() public view returns(uint) {\n', '    return liqFeePool + liqFeeSystem + liqFeeCaller;\n', '  }\n', '}']