['pragma solidity ^0.5.8;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor() public {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter);\n', '    }\n', '}\n', '\n', '\n', '/// @title Main contract for WrappedCK. This contract converts Cryptokitties between the ERC721 standard and the\n', '///  ERC20 standard by locking cryptokitties into the contract and minting 1:1 backed ERC20 tokens, that\n', '///  can then be redeemed for cryptokitties when desired.\n', '/// @notice When wrapping a cryptokitty, you get a generic WCK token. Since the WCK token is generic, it has no\n', '///  no information about what cryptokitty you submitted, so you will most likely not receive the same kitty\n', "///  back when redeeming the token unless you specify that kitty's ID. The token only entitles you to receive \n", '///  *a* cryptokitty in return, not necessarily the *same* cryptokitty in return. A different user can submit\n', '///  their own WCK tokens to the contract and withdraw the kitty that you originally deposited. WCK tokens have\n', '///  no information about which kitty was originally deposited to mint WCK - this is due to the very nature of \n', '///  the ERC20 standard being fungible, and the ERC721 standard being nonfungible.\n', 'contract WrappedCK is ERC20, ReentrancyGuard {\n', '\n', "    // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.\n", '    using SafeMath for uint256;\n', '\n', '    /* ****** */\n', '    /* EVENTS */\n', '    /* ****** */\n', '\n', '    /// @dev This event is fired when a user deposits cryptokitties into the contract in exchange\n', '    ///  for an equal number of WCK ERC20 tokens.\n', '    /// @param kittyId  The cryptokitty id of the kitty that was deposited into the contract.\n', '    event DepositKittyAndMintToken(\n', '        uint256 kittyId\n', '    );\n', '\n', '    /// @dev This event is fired when a user deposits WCK ERC20 tokens into the contract in exchange\n', '    ///  for an equal number of locked cryptokitties.\n', '    /// @param kittyId  The cryptokitty id of the kitty that was withdrawn from the contract.\n', '    event BurnTokenAndWithdrawKitty(\n', '        uint256 kittyId\n', '    );\n', '\n', '    /* ******* */\n', '    /* STORAGE */\n', '    /* ******* */\n', '\n', '    /// @dev An Array containing all of the cryptokitties that are locked in the contract, backing\n', '    ///  WCK ERC20 tokens 1:1\n', '    /// @notice Some of the kitties in this array were indeed deposited to the contract, but they\n', '    ///  are no longer held by the contract. This is because withdrawSpecificKitty() allows a \n', '    ///  user to withdraw a kitty "out of order". Since it would be prohibitively expensive to \n', "    ///  shift the entire array once we've withdrawn a single element, we instead maintain this \n", '    ///  mapping to determine whether an element is still contained in the contract or not. \n', '    uint256[] private depositedKittiesArray;\n', '\n', '    /// @dev A mapping keeping track of which kittyIDs are currently contained within the contract.\n', '    /// @notice We cannot rely on depositedKittiesArray as the source of truth as to which cats are\n', '    ///  deposited in the contract. This is because burnTokensAndWithdrawKitties() allows a user to \n', '    ///  withdraw a kitty "out of order" of the order that they are stored in the array. Since it \n', "    ///  would be prohibitively expensive to shift the entire array once we've withdrawn a single \n", '    ///  element, we instead maintain this mapping to determine whether an element is still contained \n', '    ///  in the contract or not. \n', '    mapping (uint256 => bool) private kittyIsDepositedInContract;\n', '\n', '    /* ********* */\n', '    /* CONSTANTS */\n', '    /* ********* */\n', '\n', '    /// @dev The metadata details about the "Wrapped CryptoKitties" WCK ERC20 token.\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "Wrapped CryptoKitties";\n', '    string constant public symbol = "WCK";\n', '\n', '    /// @dev The address of official CryptoKitties contract that stores the metadata about each cat.\n', '    /// @notice The owner is not capable of changing the address of the CryptoKitties Core contract\n', '    ///  once the contract has been deployed.\n', '    address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;\n', '    KittyCore kittyCore;\n', '\n', '    /* ********* */\n', '    /* FUNCTIONS */\n', '    /* ********* */\n', '\n', '    /// @notice Allows a user to lock cryptokitties in the contract in exchange for an equal number\n', '    ///  of WCK ERC20 tokens.\n', '    /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.\n', '    /// @notice The user must first call approve() in the Cryptokitties Core contract on each kitty\n', '    ///  that thye wish to deposit before calling depositKittiesAndMintTokens(). There is no danger \n', "    ///  of this contract overreaching its approval, since the CryptoKitties Core contract's approve() \n", '    ///  function only approves this contract for a single Cryptokitty. Calling approve() allows this \n', '    ///  contract to transfer the specified kitty in the depositKittiesAndMintTokens() function.\n', '    function depositKittiesAndMintTokens(uint256[] calldata _kittyIds) external nonReentrant {\n', "        require(_kittyIds.length > 0, 'you must submit an array with at least one element');\n", '        for(uint i = 0; i < _kittyIds.length; i++){\n', '            uint256 kittyToDeposit = _kittyIds[i];\n', "            require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');\n", "            require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');\n", '            kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);\n', '            _pushKitty(kittyToDeposit);\n', '            emit DepositKittyAndMintToken(kittyToDeposit);\n', '        }\n', '        _mint(msg.sender, (_kittyIds.length).mul(10**18));\n', '    }\n', '\n', '    /// @notice Allows a user to burn WCK ERC20 tokens in exchange for an equal number of locked \n', '    ///  cryptokitties.\n', '    /// @param _kittyIds  The IDs of the kitties that the user wishes to withdraw. If the user submits 0 \n', '    ///  as the ID for any kitty, the contract uses the last kitty in the array for that kitty.\n', '    /// @param _destinationAddresses  The addresses that the withdrawn kitties will be sent to (this allows \n', '    ///  anyone to "airdrop" kitties to addresses that they do not own in a single transaction).\n', '    function burnTokensAndWithdrawKitties(uint256[] calldata _kittyIds, address[] calldata _destinationAddresses) external nonReentrant {\n', "        require(_kittyIds.length == _destinationAddresses.length, 'you did not provide a destination address for each of the cats you wish to withdraw');\n", "        require(_kittyIds.length > 0, 'you must submit an array with at least one element');\n", '\n', '        uint256 numTokensToBurn = _kittyIds.length;\n', "        require(balanceOf(msg.sender) >= numTokensToBurn.mul(10**18), 'you do not own enough tokens to withdraw this many ERC721 cats');\n", '        _burn(msg.sender, numTokensToBurn.mul(10**18));\n', '        \n', '        for(uint i = 0; i < numTokensToBurn; i++){\n', '            uint256 kittyToWithdraw = _kittyIds[i];\n', '            if(kittyToWithdraw == 0){\n', '                kittyToWithdraw = _popKitty();\n', '            } else {\n', "                require(kittyIsDepositedInContract[kittyToWithdraw] == true, 'this kitty has already been withdrawn');\n", "                require(address(this) == kittyCore.ownerOf(kittyToWithdraw), 'the contract does not own this cat');\n", '                kittyIsDepositedInContract[kittyToWithdraw] = false;\n', '            }\n', '            kittyCore.transfer(_destinationAddresses[i], kittyToWithdraw);\n', '            emit BurnTokenAndWithdrawKitty(kittyToWithdraw);\n', '        }\n', '    }\n', '\n', '    /// @notice Adds a locked cryptokitty to the end of the array\n', '    /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.\n', '    function _pushKitty(uint256 _kittyId) internal {\n', '        depositedKittiesArray.push(_kittyId);\n', '        kittyIsDepositedInContract[_kittyId] = true;\n', '    }\n', '\n', '    /// @notice Removes an unlocked cryptokitty from the end of the array\n', '    /// @notice The reason that this function must check if the kittyIsDepositedInContract\n', '    ///  is that the withdrawSpecificKitty() function allows a user to withdraw a kitty\n', '    ///  from the array out of order.\n', '    /// @return  The id of the cryptokitty that will be unlocked from the contract.\n', '    function _popKitty() internal returns(uint256){\n', "        require(depositedKittiesArray.length > 0, 'there are no cats in the array');\n", '        uint256 kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];\n', '        depositedKittiesArray.length--;\n', '        while(kittyIsDepositedInContract[kittyId] == false){\n', '            kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];\n', '            depositedKittiesArray.length--;\n', '        }\n', '        kittyIsDepositedInContract[kittyId] = false;\n', '        return kittyId;\n', '    }\n', '\n', '    /// @notice Removes any kitties that exist in the array but are no longer held in the\n', '    ///  contract, which happens if the first few kitties have previously been withdrawn \n', '    ///  out of order using the withdrawSpecificKitty() function.\n', '    /// @notice This function exists to prevent a griefing attack where a malicious attacker\n', '    ///  could call withdrawSpecificKitty() on a large number of kitties at the front of the\n', '    ///  array, causing the while-loop in _popKitty to always run out of gas.\n', '    /// @param _numSlotsToCheck  The number of slots to check in the array.\n', '    function batchRemoveWithdrawnKittiesFromStorage(uint256 _numSlotsToCheck) external {\n', "        require(_numSlotsToCheck <= depositedKittiesArray.length, 'you are trying to batch remove more slots than exist in the array');\n", '        uint256 arrayIndex = depositedKittiesArray.length;\n', '        for(uint i = 0; i < _numSlotsToCheck; i++){\n', '            arrayIndex = arrayIndex.sub(1);\n', '            uint256 kittyId = depositedKittiesArray[arrayIndex];\n', '            if(kittyIsDepositedInContract[kittyId] == false){\n', '                depositedKittiesArray.length--;\n', '            } else {\n', '                return;\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice The owner is not capable of changing the address of the CryptoKitties Core\n', '    ///  contract once the contract has been deployed.\n', '    constructor() public {\n', '        kittyCore = KittyCore(kittyCoreAddress);\n', '    }\n', '\n', '    /// @dev We leave the fallback function payable in case the current State Rent proposals require\n', '    ///  us to send funds to this contract to keep it alive on mainnet.\n', '    /// @notice There is no function that allows the contract creator to withdraw any funds sent\n', '    ///  to this contract, so any funds sent directly to the fallback function that are not used for \n', '    ///  State Rent are lost forever.\n', '    function() external payable {}\n', '}\n', '\n', '/// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.\n', 'contract KittyCore {\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) external;\n', '    function transfer(address _to, uint256 _tokenId) external;\n', '    mapping (uint256 => address) public kittyIndexToApproved;\n', '}']