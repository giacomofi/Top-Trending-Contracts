['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title Token\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract Token {\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract AirDrop is Ownable {\n', '\n', '  // This declares a state variable that would store the contract address\n', '  Token public tokenInstance;\n', '\n', '  /*\n', '    constructor function to set token address\n', '   */\n', '  function AirDrop(address _tokenAddress){\n', '    tokenInstance = Token(_tokenAddress);\n', '  }\n', '\n', '  /*\n', '    Airdrop function which take up a array of address,token amount and eth amount and call the\n', '    transfer function to send the token plus send eth to the address is balance is 0\n', '   */\n', '  function doAirDrop(address[] _address, uint256[] _amount, uint256 _ethAmount) onlyOwner public returns (bool) {\n', '    uint256 count = _address.length;\n', '    for (uint256 i = 0; i < count; i++)\n', '    {\n', '      /* calling transfer function from contract */\n', '      tokenInstance.transfer(_address [i],_amount [i]);\n', '      if((_address [i].balance == 0) && (this.balance >= _ethAmount))\n', '      {\n', '        require(_address [i].send(_ethAmount));\n', '      }\n', '    }\n', '  }\n', '\n', '\n', '  function transferEthToOnwer() onlyOwner public returns (bool) {\n', '    require(owner.send(this.balance));\n', '  }\n', '\n', '  /*\n', '    function to add eth to the contract\n', '   */\n', '  function() payable {\n', '\n', '  }\n', '\n', '  /*\n', '    function to kill contract\n', '  */\n', '\n', '  function kill() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title Token\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract Token {\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract AirDrop is Ownable {\n', '\n', '  // This declares a state variable that would store the contract address\n', '  Token public tokenInstance;\n', '\n', '  /*\n', '    constructor function to set token address\n', '   */\n', '  function AirDrop(address _tokenAddress){\n', '    tokenInstance = Token(_tokenAddress);\n', '  }\n', '\n', '  /*\n', '    Airdrop function which take up a array of address,token amount and eth amount and call the\n', '    transfer function to send the token plus send eth to the address is balance is 0\n', '   */\n', '  function doAirDrop(address[] _address, uint256[] _amount, uint256 _ethAmount) onlyOwner public returns (bool) {\n', '    uint256 count = _address.length;\n', '    for (uint256 i = 0; i < count; i++)\n', '    {\n', '      /* calling transfer function from contract */\n', '      tokenInstance.transfer(_address [i],_amount [i]);\n', '      if((_address [i].balance == 0) && (this.balance >= _ethAmount))\n', '      {\n', '        require(_address [i].send(_ethAmount));\n', '      }\n', '    }\n', '  }\n', '\n', '\n', '  function transferEthToOnwer() onlyOwner public returns (bool) {\n', '    require(owner.send(this.balance));\n', '  }\n', '\n', '  /*\n', '    function to add eth to the contract\n', '   */\n', '  function() payable {\n', '\n', '  }\n', '\n', '  /*\n', '    function to kill contract\n', '  */\n', '\n', '  function kill() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '}']
