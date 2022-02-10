['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Interface for the standard token.\n', ' * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'interface EIP20Token {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '  function approve(address spender, uint256 value) external returns (bool success);\n', '  function allowance(address owner, address spender) external view returns (uint256 remaining);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// The owner of this contract should be an externally owned account\n', 'contract OlyseumPurchase is Ownable {\n', '\n', '  // Address of the target contract\n', '  address public purchase_address = 0x04A1af06961E8FAFb82bF656e135B67C130EF240;\n', '  // Major partner address\n', '  address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;\n', '  // Minor partner address\n', '  address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;\n', '  // Third partner address\n', '  address public third_partner_address = 0x70d496dA196c522ee0269855B1bC8E92D1D5589b;\n', '  // Additional gas used for transfers.\n', '  uint public gas = 1000;\n', '\n', '  // Payments to this contract require a bit of gas. 100k should be enough.\n', '  function() payable public {\n', '    execute_transfer(msg.value);\n', '  }\n', '\n', '  // Transfer some funds to the target purchase address.\n', '  function execute_transfer(uint transfer_amount) internal {\n', '    // Major fee is amount*15/10/105\n', '    uint major_fee = transfer_amount * 15 / 10 / 105;\n', '    // Minor fee is amount/105\n', '    uint minor_fee = transfer_amount / 105;\n', '    // Third fee is amount*25/10/105\n', '    uint third_fee = transfer_amount * 25 / 10 / 105;\n', '\n', '    require(major_partner_address.call.gas(gas).value(major_fee)());\n', '    require(minor_partner_address.call.gas(gas).value(minor_fee)());\n', '    require(third_partner_address.call.gas(gas).value(third_fee)());\n', '\n', '    // Send the rest\n', '    uint purchase_amount = transfer_amount - major_fee - minor_fee - third_fee;\n', '    require(purchase_address.call.gas(gas).value(purchase_amount)());\n', '  }\n', '\n', '  // Sets the amount of additional gas allowed to addresses called\n', '  // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.\n', '  //  \n', '  function set_transfer_gas(uint transfer_gas) public onlyOwner {\n', '    gas = transfer_gas;\n', '  }\n', '\n', '  // We can use this function to move unwanted tokens in the contract\n', '  function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {\n', '    token.approve(dest, value);\n', '  }\n', '\n', '  // This contract is designed to have no balance.\n', '  // However, we include this function to avoid stuck value by some unknown mishap.\n', '  function emergency_withdraw() public onlyOwner {\n', '    require(msg.sender.call.gas(gas).value(this.balance)());\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Interface for the standard token.\n', ' * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'interface EIP20Token {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '  function approve(address spender, uint256 value) external returns (bool success);\n', '  function allowance(address owner, address spender) external view returns (uint256 remaining);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// The owner of this contract should be an externally owned account\n', 'contract OlyseumPurchase is Ownable {\n', '\n', '  // Address of the target contract\n', '  address public purchase_address = 0x04A1af06961E8FAFb82bF656e135B67C130EF240;\n', '  // Major partner address\n', '  address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;\n', '  // Minor partner address\n', '  address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;\n', '  // Third partner address\n', '  address public third_partner_address = 0x70d496dA196c522ee0269855B1bC8E92D1D5589b;\n', '  // Additional gas used for transfers.\n', '  uint public gas = 1000;\n', '\n', '  // Payments to this contract require a bit of gas. 100k should be enough.\n', '  function() payable public {\n', '    execute_transfer(msg.value);\n', '  }\n', '\n', '  // Transfer some funds to the target purchase address.\n', '  function execute_transfer(uint transfer_amount) internal {\n', '    // Major fee is amount*15/10/105\n', '    uint major_fee = transfer_amount * 15 / 10 / 105;\n', '    // Minor fee is amount/105\n', '    uint minor_fee = transfer_amount / 105;\n', '    // Third fee is amount*25/10/105\n', '    uint third_fee = transfer_amount * 25 / 10 / 105;\n', '\n', '    require(major_partner_address.call.gas(gas).value(major_fee)());\n', '    require(minor_partner_address.call.gas(gas).value(minor_fee)());\n', '    require(third_partner_address.call.gas(gas).value(third_fee)());\n', '\n', '    // Send the rest\n', '    uint purchase_amount = transfer_amount - major_fee - minor_fee - third_fee;\n', '    require(purchase_address.call.gas(gas).value(purchase_amount)());\n', '  }\n', '\n', '  // Sets the amount of additional gas allowed to addresses called\n', '  // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.\n', '  //  \n', '  function set_transfer_gas(uint transfer_gas) public onlyOwner {\n', '    gas = transfer_gas;\n', '  }\n', '\n', '  // We can use this function to move unwanted tokens in the contract\n', '  function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {\n', '    token.approve(dest, value);\n', '  }\n', '\n', '  // This contract is designed to have no balance.\n', '  // However, we include this function to avoid stuck value by some unknown mishap.\n', '  function emergency_withdraw() public onlyOwner {\n', '    require(msg.sender.call.gas(gas).value(this.balance)());\n', '  }\n', '\n', '}']
