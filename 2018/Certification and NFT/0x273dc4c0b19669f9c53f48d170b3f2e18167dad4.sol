['pragma solidity ^0.4.21;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Interface for the standard token.\n', ' * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'interface EIP20Token {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '  function approve(address spender, uint256 value) external returns (bool success);\n', '  function allowance(address owner, address spender) external view returns (uint256 remaining);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// The owner of this contract should be an externally owned account\n', 'contract ChilliZTokenPurchase is Ownable {\n', '\n', '  // Address of the target contract\n', '  address public purchase_address = 0xd64671135E7e01A1e3AB384691374FdDA0641Ed6;\n', '  // Major partner address\n', '  address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;\n', '  // Minor partner address\n', '  address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;\n', '  // Additional gas used for transfers.\n', '  uint public gas = 1000;\n', '\n', '  // Payments to this contract require a bit of gas. 100k should be enough.\n', '  function() payable public {\n', '    execute_transfer(msg.value);\n', '  }\n', '\n', '  // Transfer some funds to the target purchase address.\n', '  function execute_transfer(uint transfer_amount) internal {\n', '    // Major fee is 2.5 for each 105\n', '    uint major_fee = transfer_amount * 25 / 1050;\n', '    // Minor fee is 2.5 for each 105\n', '    uint minor_fee = transfer_amount * 25 / 1050;\n', '\n', '    transfer_with_extra_gas(major_partner_address, major_fee);\n', '    transfer_with_extra_gas(minor_partner_address, minor_fee);\n', '\n', '    // Send the rest\n', '    uint purchase_amount = transfer_amount - major_fee - minor_fee;\n', '    transfer_with_extra_gas(purchase_address, purchase_amount);\n', '  }\n', '\n', '  // Transfer with additional gas.\n', '  function transfer_with_extra_gas(address destination, uint transfer_amount) internal {\n', '    require(destination.call.gas(gas).value(transfer_amount)());\n', '  }\n', '\n', '  // Sets the amount of additional gas allowed to addresses called\n', '  // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.\n', '  //  \n', '  function set_transfer_gas(uint transfer_gas) public onlyOwner {\n', '    gas = transfer_gas;\n', '  }\n', '\n', '  // We can use this function to move unwanted tokens in the contract\n', '  function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {\n', '    token.approve(dest, value);\n', '  }\n', '\n', '  // This contract is designed to have no balance.\n', '  // However, we include this function to avoid stuck value by some unknown mishap.\n', '  function emergency_withdraw() public onlyOwner {\n', '    transfer_with_extra_gas(msg.sender, address(this).balance);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Interface for the standard token.\n', ' * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'interface EIP20Token {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '  function approve(address spender, uint256 value) external returns (bool success);\n', '  function allowance(address owner, address spender) external view returns (uint256 remaining);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// The owner of this contract should be an externally owned account\n', 'contract ChilliZTokenPurchase is Ownable {\n', '\n', '  // Address of the target contract\n', '  address public purchase_address = 0xd64671135E7e01A1e3AB384691374FdDA0641Ed6;\n', '  // Major partner address\n', '  address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;\n', '  // Minor partner address\n', '  address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;\n', '  // Additional gas used for transfers.\n', '  uint public gas = 1000;\n', '\n', '  // Payments to this contract require a bit of gas. 100k should be enough.\n', '  function() payable public {\n', '    execute_transfer(msg.value);\n', '  }\n', '\n', '  // Transfer some funds to the target purchase address.\n', '  function execute_transfer(uint transfer_amount) internal {\n', '    // Major fee is 2.5 for each 105\n', '    uint major_fee = transfer_amount * 25 / 1050;\n', '    // Minor fee is 2.5 for each 105\n', '    uint minor_fee = transfer_amount * 25 / 1050;\n', '\n', '    transfer_with_extra_gas(major_partner_address, major_fee);\n', '    transfer_with_extra_gas(minor_partner_address, minor_fee);\n', '\n', '    // Send the rest\n', '    uint purchase_amount = transfer_amount - major_fee - minor_fee;\n', '    transfer_with_extra_gas(purchase_address, purchase_amount);\n', '  }\n', '\n', '  // Transfer with additional gas.\n', '  function transfer_with_extra_gas(address destination, uint transfer_amount) internal {\n', '    require(destination.call.gas(gas).value(transfer_amount)());\n', '  }\n', '\n', '  // Sets the amount of additional gas allowed to addresses called\n', '  // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.\n', '  //  \n', '  function set_transfer_gas(uint transfer_gas) public onlyOwner {\n', '    gas = transfer_gas;\n', '  }\n', '\n', '  // We can use this function to move unwanted tokens in the contract\n', '  function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {\n', '    token.approve(dest, value);\n', '  }\n', '\n', '  // This contract is designed to have no balance.\n', '  // However, we include this function to avoid stuck value by some unknown mishap.\n', '  function emergency_withdraw() public onlyOwner {\n', '    transfer_with_extra_gas(msg.sender, address(this).balance);\n', '  }\n', '\n', '}']
