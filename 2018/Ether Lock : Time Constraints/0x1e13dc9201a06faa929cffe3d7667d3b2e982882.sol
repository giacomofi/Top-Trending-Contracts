['pragma solidity ^0.4.17;\n', '\n', 'contract NovaAccessControl {\n', '  mapping (address => bool) managers;\n', '  address public cfoAddress;\n', '\n', '  function NovaAccessControl() public {\n', '    managers[msg.sender] = true;\n', '  }\n', '\n', '  modifier onlyManager() {\n', '    require(managers[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  function setManager(address _newManager) external onlyManager {\n', '    require(_newManager != address(0));\n', '    managers[_newManager] = true;\n', '  }\n', '\n', '  function removeManager(address mangerAddress) external onlyManager {\n', '    require(mangerAddress != msg.sender);\n', '    managers[mangerAddress] = false;\n', '  }\n', '\n', '  function updateCfo(address newCfoAddress) external onlyManager {\n', '    require(newCfoAddress != address(0));\n', '    cfoAddress = newCfoAddress;\n', '  }\n', '}\n', '\n', 'contract NovaCoin is NovaAccessControl {\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public totalSupply;\n', '  address supplier;\n', '  // 1:1 convert with currency, so to cent\n', '  uint8 public decimals = 2;\n', '  mapping (address => uint256) public balanceOf;\n', '  address public novaContractAddress;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Burn(address indexed from, uint256 value);\n', '  event NovaCoinTransfer(address indexed to, uint256 value);\n', '\n', '  function NovaCoin(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '    totalSupply = initialSupply * 10 ** uint256(decimals);\n', '    supplier = msg.sender;\n', '    balanceOf[supplier] = totalSupply;\n', '    name = tokenName;\n', '    symbol = tokenSymbol;\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    require(_to != 0x0);\n', '    require(balanceOf[_from] >= _value);\n', '    require(balanceOf[_to] + _value > balanceOf[_to]);\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) external {\n', '    _transfer(msg.sender, _to, _value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function novaTransfer(address _to, uint256 _value) external onlyManager {\n', '    _transfer(supplier, _to, _value);\n', '    NovaCoinTransfer(_to, _value);\n', '  }\n', '\n', '  function updateNovaContractAddress(address novaAddress) external onlyManager {\n', '    novaContractAddress = novaAddress;\n', '  }\n', '\n', '  function consumeCoinForNova(address _from, uint _value) external {\n', '    require(msg.sender == novaContractAddress);\n', '    _transfer(_from, novaContractAddress, _value);\n', '  }\n', '}']