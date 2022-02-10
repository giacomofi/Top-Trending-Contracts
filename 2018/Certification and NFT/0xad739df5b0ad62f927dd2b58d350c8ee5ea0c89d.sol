['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// The owner of this contract should be an externally owned account\n', 'contract TariInvestment is Ownable {\n', '\n', '  // Address of the target contract\n', '  address public investment_address = 0x33eFC5120D99a63bdF990013ECaBbd6c900803CE;\n', '  // Major partner address\n', '  address public major_partner_address = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;\n', '  // Minor partner address\n', '  address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;\n', '  // Gas used for transfers.\n', '  uint public gas = 3000;\n', '\n', '  // Payments to this contract require a bit of gas. 100k should be enough.\n', '  function() payable public {\n', '    execute_transfer(msg.value);\n', '  }\n', '\n', '  // Transfer some funds to the target investment address.\n', '  function execute_transfer(uint transfer_amount) internal {\n', '    // Major fee is 1,50% = 15 / 1000\n', '    uint major_fee = transfer_amount * 15 / 1000;\n', '    // Minor fee is 1% = 10 / 1000\n', '    uint minor_fee = transfer_amount * 10 / 1000;\n', '\n', '    require(major_partner_address.call.gas(gas).value(major_fee)());\n', '    require(minor_partner_address.call.gas(gas).value(minor_fee)());\n', '\n', '    // Send the rest\n', '    require(investment_address.call.gas(gas).value(transfer_amount - major_fee - minor_fee)());\n', '  }\n', '\n', '    // Sets the amount of gas allowed to investors\n', '  function set_transfer_gas(uint transfer_gas) public onlyOwner {\n', '    gas = transfer_gas;\n', '  }\n', '\n', '}']