['/**\n', ' * Copyright (c) 2018 blockimmo AG <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e68a8f8583889583a6848a89858d8f8b8b89c8858e">[email&#160;protected]</a>\n', ' * Non-Profit Open Software License 3.0 (NPOSL-3.0)\n', ' * https://opensource.org/licenses/NPOSL-3.0\n', ' */\n', '\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() public onlyPendingOwner {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title LandRegistryProxy\n', ' * @dev Points to `LandRegistry`, enabling it to be upgraded if absolutely necessary.\n', ' *\n', ' * Contracts reference `this.landRegistry` to locate `LandRegistry`.\n', ' * They also reference `owner` to identify blockimmo&#39;s &#39;administrator&#39; (currently blockimmo but ownership may be transferred to a\n', ' * contract / DAO in the near-future, or even rescinded).\n', ' *\n', ' * `TokenizedProperty` references `this` to enforce the `LandRegistry` and route blockimmo&#39;s 1% transaction fee on dividend payouts.\n', ' * `ShareholderDAO` references `this` to allow blockimmo&#39;s &#39;administrator&#39; to extend proposals for any `TokenizedProperty`.\n', ' * `TokenSale` references `this` to route blockimmo&#39;s 1% transaction fee on sales.\n', ' *\n', ' * For now this centralized &#39;administrator&#39; provides an extra layer of control / security until our contracts are time and battle tested.\n', ' *\n', ' * This contract is never intended to be upgraded.\n', ' */\n', 'contract LandRegistryProxy is Claimable {\n', '  address public landRegistry;\n', '\n', '  event Set(address indexed landRegistry);\n', '\n', '  function set(address _landRegistry) public onlyOwner {\n', '    landRegistry = _landRegistry;\n', '    emit Set(landRegistry);\n', '  }\n', '}']
['/**\n', ' * Copyright (c) 2018 blockimmo AG license@blockimmo.ch\n', ' * Non-Profit Open Software License 3.0 (NPOSL-3.0)\n', ' * https://opensource.org/licenses/NPOSL-3.0\n', ' */\n', '\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() public onlyPendingOwner {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title LandRegistryProxy\n', ' * @dev Points to `LandRegistry`, enabling it to be upgraded if absolutely necessary.\n', ' *\n', ' * Contracts reference `this.landRegistry` to locate `LandRegistry`.\n', " * They also reference `owner` to identify blockimmo's 'administrator' (currently blockimmo but ownership may be transferred to a\n", ' * contract / DAO in the near-future, or even rescinded).\n', ' *\n', " * `TokenizedProperty` references `this` to enforce the `LandRegistry` and route blockimmo's 1% transaction fee on dividend payouts.\n", " * `ShareholderDAO` references `this` to allow blockimmo's 'administrator' to extend proposals for any `TokenizedProperty`.\n", " * `TokenSale` references `this` to route blockimmo's 1% transaction fee on sales.\n", ' *\n', " * For now this centralized 'administrator' provides an extra layer of control / security until our contracts are time and battle tested.\n", ' *\n', ' * This contract is never intended to be upgraded.\n', ' */\n', 'contract LandRegistryProxy is Claimable {\n', '  address public landRegistry;\n', '\n', '  event Set(address indexed landRegistry);\n', '\n', '  function set(address _landRegistry) public onlyOwner {\n', '    landRegistry = _landRegistry;\n', '    emit Set(landRegistry);\n', '  }\n', '}']