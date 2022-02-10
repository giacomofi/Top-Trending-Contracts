['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-17\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '  function initialize() external;\n', '  function totalSupply() external view returns (uint);\n', '  function balanceOf(address account) external view returns (uint);\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint);\n', '  function symbol() external view returns (string memory);\n', '  function decimals() external view returns (uint);\n', '  function approve(address spender, uint amount) external returns (bool);\n', '  function mint(address account, uint amount) external;\n', '  function burn(address account, uint amount) external;\n', '  function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'interface IInterestRateModel {\n', '  function systemRate(ILendingPair _pair) external view returns(uint);\n', '  function supplyRatePerBlock(ILendingPair _pair, address _token) external view returns(uint);\n', '  function borrowRatePerBlock(ILendingPair _pair, address _token) external view returns(uint);\n', '}\n', '\n', 'interface IController {\n', '  function interestRateModel() external view returns(IInterestRateModel);\n', '  function feeRecipient() external view returns(address);\n', '  function liqMinHealth() external view returns(uint);\n', '  function liqFeePool() external view returns(uint);\n', '  function liqFeeSystem() external view returns(uint);\n', '  function liqFeeCaller() external view returns(uint);\n', '  function liqFeesTotal() external view returns(uint);\n', '  function tokenPrice(address _token) external view returns(uint);\n', '  function depositLimit(address _lendingPair, address _token) external view returns(uint);\n', '  function setFeeRecipient(address _feeRecipient) external;\n', '}\n', '\n', 'interface ILendingPair {\n', '  function checkAccountHealth(address _account) external view;\n', '  function accrueAccount(address _account) external;\n', '  function accrue() external;\n', '  function accountHealth(address _account) external view returns(uint);\n', '  function totalDebt(address _token) external view returns(uint);\n', '  function tokenA() external view returns(address);\n', '  function tokenB() external view returns(address);\n', '  function lpToken(address _token) external view returns(IERC20);\n', '  function debtOf(address _account, address _token) external view returns(uint);\n', '  function deposit(address _token, uint _amount) external;\n', '  function withdraw(address _token, uint _amount) external;\n', '  function borrow(address _token, uint _amount) external;\n', '  function repay(address _token, uint _amount) external;\n', '  function withdrawRepay(address _token, uint _amount) external;\n', '  function withdrawBorrow(address _token, uint _amount) external;\n', '  function controller() external view returns(IController);\n', '\n', '  function convertTokenValues(\n', '    address _fromToken,\n', '    address _toToken,\n', '    uint    _inputAmount\n', '  ) external view returns(uint);\n', '}\n', '\n', 'interface IFeeConverter {\n', '\n', '  function convert(\n', '    address _sender,\n', '    ILendingPair _pair,\n', '    address[] memory _path,\n', '    uint _supplyTokenAmount\n', '  ) external;\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() {\n', '    owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), owner);\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns (bool) {\n', '    return msg.sender == owner;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(owner, address(0));\n', '    owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract FeeRecipient is Ownable {\n', '\n', '  IFeeConverter public feeConverter;\n', '\n', '  constructor(IFeeConverter _feeConverter) {\n', '    feeConverter = _feeConverter;\n', '  }\n', '\n', '  function convert(\n', '    ILendingPair _pair,\n', '    address[] memory _path\n', '  ) public {\n', '    IERC20 lpToken = IERC20(_pair.lpToken(_path[0]));\n', '    uint supplyTokenAmount = lpToken.balanceOf(address(this));\n', '    lpToken.transfer(address(feeConverter), supplyTokenAmount);\n', '    feeConverter.convert(msg.sender, _pair, _path, supplyTokenAmount);\n', '  }\n', '\n', '  function setFeeConverter(IFeeConverter _value) onlyOwner public {\n', '    feeConverter = _value;\n', '  }\n', '}']