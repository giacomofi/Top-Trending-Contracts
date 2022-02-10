['/**\n', ' *Submitted for verification at Etherscan.io on 2020-05-06\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/zos-lib/contracts/migrations/Migratable.sol\n', '\n', '/**\n', ' * @title Migratable\n', ' * Helper contract to support intialization and migration schemes between\n', ' * different implementations of a contract in the context of upgradeability.\n', ' * To use it, replace the constructor with a function that has the\n', ' * `isInitializer` modifier starting with `"0"` as `migrationId`.\n', ' * When you want to apply some migration code during an upgrade, increase\n', ' * the `migrationId`. Or, if the migration code must be applied only after\n', ' * another migration has been already applied, use the `isMigration` modifier.\n', ' * This helper supports multiple inheritance.\n', " * WARNING: It is the developer's responsibility to ensure that migrations are\n", ' * applied in a correct order, or that they are run at all.\n', ' * See `Initializable` for a simpler version.\n', ' */\n', 'contract Migratable {\n', '  /**\n', '   * @dev Emitted when the contract applies a migration.\n', '   * @param contractName Name of the Contract.\n', '   * @param migrationId Identifier of the migration applied.\n', '   */\n', '  event Migrated(string contractName, string migrationId);\n', '\n', '  /**\n', '   * @dev Mapping of the already applied migrations.\n', '   * (contractName => (migrationId => bool))\n', '   */\n', '  mapping (string => mapping (string => bool)) internal migrated;\n', '\n', '  /**\n', '   * @dev Internal migration id used to specify that a contract has already been initialized.\n', '   */\n', '  string constant private INITIALIZED_ID = "initialized";\n', '\n', '\n', '  /**\n', '   * @dev Modifier to use in the initialization function of a contract.\n', '   * @param contractName Name of the contract.\n', '   * @param migrationId Identifier of the migration.\n', '   */\n', '  modifier isInitializer(string contractName, string migrationId) {\n', '    validateMigrationIsPending(contractName, INITIALIZED_ID);\n', '    validateMigrationIsPending(contractName, migrationId);\n', '    _;\n', '    emit Migrated(contractName, migrationId);\n', '    migrated[contractName][migrationId] = true;\n', '    migrated[contractName][INITIALIZED_ID] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to use in the migration of a contract.\n', '   * @param contractName Name of the contract.\n', '   * @param requiredMigrationId Identifier of the previous migration, required\n', '   * to apply new one.\n', '   * @param newMigrationId Identifier of the new migration to be applied.\n', '   */\n', '  modifier isMigration(string contractName, string requiredMigrationId, string newMigrationId) {\n', '    require(isMigrated(contractName, requiredMigrationId), "Prerequisite migration ID has not been run yet");\n', '    validateMigrationIsPending(contractName, newMigrationId);\n', '    _;\n', '    emit Migrated(contractName, newMigrationId);\n', '    migrated[contractName][newMigrationId] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns true if the contract migration was applied.\n', '   * @param contractName Name of the contract.\n', '   * @param migrationId Identifier of the migration.\n', '   * @return true if the contract migration was applied, false otherwise.\n', '   */\n', '  function isMigrated(string contractName, string migrationId) public view returns(bool) {\n', '    return migrated[contractName][migrationId];\n', '  }\n', '\n', '  /**\n', '   * @dev Initializer that marks the contract as initialized.\n', '   * It is important to run this if you had deployed a previous version of a Migratable contract.\n', '   * For more information see https://github.com/zeppelinos/zos-lib/issues/158.\n', '   */\n', '  function initialize() isInitializer("Migratable", "1.2.1") public {\n', '  }\n', '\n', '  /**\n', '   * @dev Reverts if the requested migration was already executed.\n', '   * @param contractName Name of the contract.\n', '   * @param migrationId Identifier of the migration.\n', '   */\n', '  function validateMigrationIsPending(string contractName, string migrationId) private {\n', '    require(!isMigrated(contractName, migrationId), "Requested target migration ID has already been run");\n', '  }\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable is Migratable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function initialize(address _sender) public isInitializer("Ownable", "1.9.0") {\n', '    owner = _sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/contracts/Escrow.sol\n', '\n', '/**\n', ' * @title Escrow\n', ' * @dev Escrow contract that works with RNDR token\n', ' * This contract holds tokens while render jobs are being completed\n', ' * and information on token allottment per job\n', ' */\n', 'contract Escrow is Migratable, Ownable {\n', '  using SafeERC20 for ERC20;\n', '  using SafeMath for uint256;\n', '\n', '  // This is a mapping of job IDs to the number of tokens allotted to the job\n', '  mapping(string => uint256) private jobBalances;\n', '  // This is the address of the render token contract\n', '  address public renderTokenAddress;\n', '  // This is the address with authority to call the disburseJob function\n', '  address public disbursalAddress;\n', '\n', '  // Emit new disbursal address when disbursalAddress has been changed\n', '  event DisbursalAddressUpdate(address disbursalAddress);\n', '  // Emit the jobId along with the new balance of the job\n', '  // Used on job creation, additional funding added to jobs, and job disbursal\n', '  // Internal systems for assigning jobs will watch this event to determine balances available\n', '  event JobBalanceUpdate(string _jobId, uint256 _balance);\n', '  // Emit new contract address when renderTokenAddress has been changed\n', '  event RenderTokenAddressUpdate(address renderTokenAddress);\n', '\n', '  /**\n', '   * @dev Modifier to check if the message sender can call the disburseJob function\n', '   */\n', '  modifier canDisburse() {\n', '    require(msg.sender == disbursalAddress, "message sender not authorized to disburse funds");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Initailization\n', '   * @param _owner because this contract uses proxies, owner must be passed in as a param\n', '   * @param _renderTokenAddress see renderTokenAddress\n', '   */\n', '  function initialize (address _owner, address _renderTokenAddress) public isInitializer("Escrow", "0") {\n', '    require(_owner != address(0), "_owner must not be null");\n', '    require(_renderTokenAddress != address(0), "_renderTokenAddress must not be null");\n', '    Ownable.initialize(_owner);\n', '    disbursalAddress = _owner;\n', '    renderTokenAddress = _renderTokenAddress;\n', '  }\n', '\n', '  /**\n', '   * @dev Change the address authorized to distribute tokens for completed jobs\n', '   *\n', '   * Because there are no on-chain details to indicate who performed a render, an outside\n', '   * system must call the disburseJob function with the information needed to properly\n', '   * distribute tokens. This function updates the address with the authority to perform distributions\n', '   * @param _newDisbursalAddress see disbursalAddress\n', '   */\n', '  function changeDisbursalAddress(address _newDisbursalAddress) external onlyOwner {\n', '    disbursalAddress = _newDisbursalAddress;\n', '\n', '    emit DisbursalAddressUpdate(disbursalAddress);\n', '  }\n', '\n', '  /**\n', '   * @dev Change the address allowances will be sent to after job completion\n', '   *\n', '   * Ideally, this will not be used, but is included as a failsafe.\n', '   * RNDR is still in its infancy, and changes may need to be made to this\n', '   * contract and / or the renderToken contract. Including methods to update the\n', '   * addresses allows the contracts to update independently.\n', '   * If the RNDR token contract is ever migrated to another address for\n', '   * either added security or functionality, this will need to be called.\n', '   * @param _newRenderTokenAddress see renderTokenAddress\n', '   */\n', '  function changeRenderTokenAddress(address _newRenderTokenAddress) external onlyOwner {\n', '    require(_newRenderTokenAddress != address(0), "_newRenderTokenAddress must not be null");\n', '    renderTokenAddress = _newRenderTokenAddress;\n', '\n', '    emit RenderTokenAddressUpdate(renderTokenAddress);\n', '  }\n', '\n', '  /**\n', '   * @dev Send allowances to node(s) that performed a job\n', '   *\n', '   * This can only be called by the disbursalAddress, an accound owned\n', '   * by OTOY, and it provides the number of tokens to send to each node\n', '   * @param _jobId the ID of the job used in the jobBalances mapping\n', '   * @param _recipients the address(es) of the nodes that performed rendering\n', '   * @param _amounts the amount(s) to send to each address. These must be in the same\n', '   * order as the recipient addresses\n', '   */\n', '  function disburseJob(string _jobId, address[] _recipients, uint256[] _amounts) external canDisburse {\n', '    require(jobBalances[_jobId] > 0, "_jobId has no available balance");\n', '    require(_recipients.length == _amounts.length, "_recipients and _amounts must be the same length");\n', '\n', '    for(uint256 i = 0; i < _recipients.length; i++) {\n', '      jobBalances[_jobId] = jobBalances[_jobId].sub(_amounts[i]);\n', '      ERC20(renderTokenAddress).safeTransfer(_recipients[i], _amounts[i]);\n', '    }\n', '\n', '    emit JobBalanceUpdate(_jobId, jobBalances[_jobId]);\n', '  }\n', '\n', '  /**\n', '   * @dev Add RNDR tokens to a job\n', '   *\n', '   * This can only be called by a function on the RNDR token contract\n', '   * @param _jobId the ID of the job used in the jobBalances mapping\n', '   * @param _tokens the number of tokens sent by the artist to fund the job\n', '   */\n', '  function fundJob(string _jobId, uint256 _tokens) external {\n', '    // Jobs can only be created by the address stored in the renderTokenAddress variable\n', '    require(msg.sender == renderTokenAddress, "message sender not authorized");\n', '    jobBalances[_jobId] = jobBalances[_jobId].add(_tokens);\n', '\n', '    emit JobBalanceUpdate(_jobId, jobBalances[_jobId]);\n', '  }\n', '\n', '  /**\n', '   * @dev See the tokens available for a job\n', '   *\n', '   * @param _jobId the ID used to lookup the job balance\n', '   */\n', '  function jobBalance(string _jobId) external view returns(uint256) {\n', '    return jobBalances[_jobId];\n', '  }\n', '\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/contracts/MigratableERC20.sol\n', '\n', '/**\n', ' * @title MigratableERC20\n', ' * @dev This strategy carries out an optional migration of the token balances. This migration is performed and paid for\n', ' * @dev by the token holders. The new token contract starts with no initial supply and no balances. The only way to\n', ' * @dev "mint" the new tokens is for users to "turn in" their old ones. This is done by first approving the amount they\n', ' * @dev want to migrate via `ERC20.approve(newTokenAddress, amountToMigrate)` and then calling a function of the new\n', ' * @dev token called `migrateTokens`. The old tokens are sent to a burn address, and the holder receives an equal amount\n', ' * @dev in the new contract.\n', ' */\n', 'contract MigratableERC20 is Migratable {\n', '  using SafeERC20 for ERC20;\n', '\n', '  /// Burn address where the old tokens are going to be transferred\n', '  address public constant BURN_ADDRESS = address(0xdead);\n', '\n', '  /// Address of the old token contract\n', '  ERC20 public legacyToken;\n', '\n', '  /**\n', '   * @dev Initializes the new token contract\n', '   * @param _legacyToken address of the old token contract\n', '   */\n', '  function initialize(address _legacyToken) isInitializer("OptInERC20Migration", "1.9.0") public {\n', '    legacyToken = ERC20(_legacyToken);\n', '  }\n', '\n', '  /**\n', '   * @dev Migrates the total balance of the token holder to this token contract\n', '   * @dev This function will burn the old token balance and mint the same balance in the new token contract\n', '   */\n', '  function migrate() public {\n', '    uint256 amount = legacyToken.balanceOf(msg.sender);\n', '    migrateToken(amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Migrates the given amount of old-token balance to the new token contract\n', '   * @dev This function will burn a given amount of tokens from the old contract and mint the same amount in the new one\n', '   * @param _amount uint256 representing the amount of tokens to be migrated\n', '   */\n', '  function migrateToken(uint256 _amount) public {\n', '    migrateTokenTo(msg.sender, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a given amount of the old token contract for a token holder and mints the same amount of\n', '   * @dev new tokens for a given recipient address\n', '   * @param _amount uint256 representing the amount of tokens to be migrated\n', '   * @param _to address the recipient that will receive the new minted tokens\n', '   */\n', '  function migrateTokenTo(address _to, uint256 _amount) public {\n', '    _mintMigratedTokens(_to, _amount);\n', '    legacyToken.safeTransferFrom(msg.sender, BURN_ADDRESS, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal minting function\n', '   * This function must be overwritten by the implementation\n', '   */\n', '  function _mintMigratedTokens(address _to, uint256 _amount) internal;\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: /Users/matthewmcclure/repos/Token-Audit/node_modules/openzeppelin-zos/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/RenderToken.sol\n', '\n', '// Escrow constract\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title RenderToken\n', ' * @dev ERC20 mintable token\n', ' * The token will be minted by the crowdsale contract only\n', ' */\n', 'contract RenderToken is Migratable, MigratableERC20, Ownable, StandardToken {\n', '\n', '  string public constant name = "Render Token";\n', '  string public constant symbol = "RNDR";\n', '  uint8 public constant decimals = 18;\n', '\n', '  // The address of the contract that manages job balances. Address is used for forwarding tokens\n', '  // that come in to fund jobs\n', '  address public escrowContractAddress;\n', '\n', '  // Emit new contract address when escrowContractAddress has been changed\n', '  event EscrowContractAddressUpdate(address escrowContractAddress);\n', '  // Emit information related to tokens being escrowed\n', '  event TokensEscrowed(address indexed sender, string jobId, uint256 amount);\n', '  // Emit information related to legacy tokens being migrated\n', '  event TokenMigration(address indexed receiver, uint256 amount);\n', '\n', '  /**\n', '   * @dev Initailization\n', '   * @param _owner because this contract uses proxies, owner must be passed in as a param\n', '   */\n', '  function initialize(address _owner, address _legacyToken) public isInitializer("RenderToken", "0") {\n', '    require(_owner != address(0), "_owner must not be null");\n', '    require(_legacyToken != address(0), "_legacyToken must not be null");\n', '    Ownable.initialize(_owner);\n', '    MigratableERC20.initialize(_legacyToken);\n', '  }\n', '\n', '  /**\n', '   * @dev Take tokens prior to beginning a job\n', '   *\n', '   * This function is called by the artist, and it will transfer tokens\n', '   * to a separate escrow contract to be held until the job is completed\n', '   * @param _jobID is the ID of the job used within the ORC backend\n', '   * @param _amount is the number of RNDR tokens being held in escrow\n', '   */\n', '  function holdInEscrow(string _jobID, uint256 _amount) public {\n', '    require(transfer(escrowContractAddress, _amount), "token transfer to escrow address failed");\n', '    Escrow(escrowContractAddress).fundJob(_jobID, _amount);\n', '\n', '    emit TokensEscrowed(msg.sender, _jobID, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Mints new tokens equal to the amount of legacy tokens burned\n', '   *\n', '   * This function is called internally, but triggered by a user choosing to\n', '   * migrate their balance.\n', '   * @param _to is the address tokens will be sent to\n', '   * @param _amount is the number of RNDR tokens being sent to the address\n', '   */\n', '  function _mintMigratedTokens(address _to, uint256 _amount) internal {\n', '    require(_to != address(0), "_to address must not be null");\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '\n', '    emit TokenMigration(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the address of the escrow contract\n', '   *\n', '   * This will dictate the contract that will hold tokens in escrow and keep\n', '   * a ledger of funds available for jobs.\n', '   * RNDR is still in its infancy, and changes may need to be made to this\n', '   * contract and / or the escrow contract. Including methods to update the\n', '   * addresses allows the contracts to update independently.\n', '   * If the escrow contract is ever migrated to another address for\n', '   * either added security or functionality, this will need to be called.\n', '   * @param _escrowAddress see escrowContractAddress\n', '   */\n', '  function setEscrowContractAddress(address _escrowAddress) public onlyOwner {\n', '    require(_escrowAddress != address(0), "_escrowAddress must not be null");\n', '    escrowContractAddress = _escrowAddress;\n', '\n', '    emit EscrowContractAddressUpdate(escrowContractAddress);\n', '  }\n', '\n', '}']