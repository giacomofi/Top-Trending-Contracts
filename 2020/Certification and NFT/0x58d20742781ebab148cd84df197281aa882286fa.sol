['// File: contracts/zeppelin/SafeMath.sol\n', '\n', 'pragma solidity >= 0.5.0 < 0.7.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/MWGImplementation.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', 'pragma solidity >= 0.5.0 < 0.7.0;\n', '\n', '\n', 'contract MWGImplementation {\n', '    /**\n', '     * MATH\n', '     */\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * DATA\n', '     */\n', '\n', '    // INITIALIZATION DATA\n', '    bool private initialized;\n', '\n', '    // ERC20 BASIC DATA\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '    string public constant name = "Motiwala Gold"; // solium-disable-line\n', '    string public constant symbol = "MWG"; // solium-disable-line uppercase\n', '    uint8 public constant decimals = 18; // solium-disable-line uppercase\n', '\n', '    // ERC20 DATA\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    // OWNER DATA\n', '    address public owner;\n', '    address public proposedOwner;\n', '\n', '    // PAUSABILITY DATA\n', '    bool public paused;\n', '\n', '    // ASSET PROTECTION DATA\n', '    address public assetProtectionRole;\n', '    mapping(address => bool) internal frozen;\n', '\n', '    // SUPPLY CONTROL DATA\n', '    address public supplyController;\n', '\n', '    // DELEGATED TRANSFER DATA\n', '    address public betaDelegateWhitelister;\n', '    mapping(address => bool) internal betaDelegateWhitelist;\n', '    mapping(address => uint256) internal nextSeqs;\n', '    // EIP191 header for EIP712 prefix\n', '    string constant internal EIP191_HEADER = "\\x19\\x01";\n', '    // Hash of the EIP712 Domain Separator Schema\n', '    bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(\n', '        "EIP712Domain(string name,address verifyingContract)"\n', '    );\n', '    bytes32 constant internal EIP712_DELEGATED_TRANSFER_SCHEMA_HASH = keccak256(\n', '        "BetaDelegatedTransfer(address to,uint256 value,uint256 serviceFee,uint256 seq,uint256 deadline)"\n', '    );\n', '    // Hash of the EIP712 Domain Separator data\n', '    // solhint-disable-next-line var-name-mixedcase\n', '    bytes32 public EIP712_DOMAIN_HASH;\n', '\n', '    // FEE CONTROLLER DATA\n', '    // fee decimals is only set for informational purposes.\n', '    // 1 feeRate = .000001 oz of gold\n', '    uint8 public constant feeDecimals = 6;\n', '\n', '    // feeRate is measured in 100th of a basis point (parts per 1,000,000)\n', '    // ex: a fee rate of 200 = 0.02% of an oz of gold\n', '    uint256 public constant feeParts = 1000000;\n', '    uint256 public feeRate;\n', '    address public feeController;\n', '    address public feeRecipient;\n', '\n', '    string public constant version = "1.0.0";\n', '\n', '    /**\n', '     * EVENTS\n', '     */\n', '\n', '    // ERC20 BASIC EVENTS\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // ERC20 EVENTS\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    // OWNABLE EVENTS\n', '    event OwnershipTransferProposed(\n', '        address indexed currentOwner,\n', '        address indexed proposedOwner\n', '    );\n', '    event OwnershipTransferDisregarded(\n', '        address indexed oldProposedOwner\n', '    );\n', '    event OwnershipTransferred(\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    // PAUSABLE EVENTS\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    // ASSET PROTECTION EVENTS\n', '    event AddressFrozen(address indexed addr);\n', '    event AddressUnfrozen(address indexed addr);\n', '    event FrozenAddressWiped(address indexed addr);\n', '    event AssetProtectionRoleSet (\n', '        address indexed oldAssetProtectionRole,\n', '        address indexed newAssetProtectionRole\n', '    );\n', '\n', '    // SUPPLY CONTROL EVENTS\n', '    event SupplyIncreased(address indexed to, uint256 value);\n', '    event SupplyDecreased(address indexed from, uint256 value);\n', '    event SupplyControllerSet(\n', '        address indexed oldSupplyController,\n', '        address indexed newSupplyController\n', '    );\n', '\n', '    // DELEGATED TRANSFER EVENTS\n', '    event BetaDelegatedTransfer(\n', '        address indexed from, address indexed to, uint256 value, uint256 seq, uint256 serviceFee\n', '    );\n', '    event BetaDelegateWhitelisterSet(\n', '        address indexed oldWhitelister,\n', '        address indexed newWhitelister\n', '    );\n', '    event BetaDelegateWhitelisted(address indexed newDelegate);\n', '    event BetaDelegateUnwhitelisted(address indexed oldDelegate);\n', '\n', '    // FEE CONTROLLER EVENTS\n', '    event FeeCollected(address indexed from, address indexed to, uint256 value);\n', '    event FeeRateSet(\n', '        uint256 indexed oldFeeRate,\n', '        uint256 indexed newFeeRate\n', '    );\n', '    event FeeControllerSet(\n', '        address indexed oldFeeController,\n', '        address indexed newFeeController\n', '    );\n', '    event FeeRecipientSet(\n', '        address indexed oldFeeRecipient,\n', '        address indexed newFeeRecipient\n', '    );\n', '\n', '    /**\n', '     * FUNCTIONALITY\n', '     */\n', '\n', '    // INITIALIZATION FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev sets 0 initial tokens, the owner, the supplyController,\n', '     * the fee controller and fee recipient.\n', '     * this serves as the constructor for the proxy but compiles to the\n', '     * memory model of the Implementation contract.\n', '     */\n', '    function initialize() public {\n', '        require(!initialized, "already initialized");\n', '        owner = msg.sender;\n', '        proposedOwner = address(0);\n', '        assetProtectionRole = address(0);\n', '        totalSupply_ = 0;\n', '        supplyController = msg.sender;\n', '        feeRate = 0;\n', '        feeController = msg.sender;\n', '        feeRecipient = msg.sender;\n', '        initializeDomainSeparator();\n', '        initialized = true;\n', '    }\n', '\n', '    /**\n', '     * The constructor is used here to ensure that the implementation\n', '     * contract is initialized. An uncontrolled implementation\n', '     * contract might lead to misleading state\n', '     * for users who accidentally interact with it.\n', '     */\n', '    // constructor() public {\n', '    //     initialize();\n', '    //     pause();\n', '    // }\n', '\n', '    /**\n', '     * @dev To be called when upgrading the contract using upgradeAndCall to add delegated transfers\n', '     */\n', '    function initializeDomainSeparator() public {\n', '        // hash the name context with the contract address\n', '        EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(// solium-disable-line\n', '                EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH, keccak256(bytes(name)), bytes32(uint256(address(this)))                ));\n', '                // bytes32(address(this))\n', '\n', '        // EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(// solium-disable-line\n', '        //         EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,\n', '        //         keccak256(bytes(name)),\n', '        //         bytes32(address(this))\n', '        //     ));\n', '\n', '    }\n', '\n', '    // ERC20 BASIC FUNCTIONALITY\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token to a specified address from msg.sender\n', '    * Transfer additionally sends the fee to the fee controller\n', '    * Note: the use of Safemath ensures that _value is nonnegative.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_to != address(0), "cannot transfer to address zero");\n', '        require(!frozen[_to] && !frozen[msg.sender], "address frozen");\n', '        require(_value <= balances[msg.sender], "insufficient funds");\n', '\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _addr The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _addr) public view returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '\n', '    // ERC20 FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '    {\n', '        require(_to != address(0), "cannot transfer to address zero");\n', '        require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");\n', '        require(_value <= balances[_from], "insufficient funds");\n', '        require(_value <= allowed[_from][msg.sender], "insufficient allowance");\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozen[_spender] && !frozen[msg.sender], "address frozen");\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal returns (uint256) {\n', '        uint256 _fee = getFeeFor(_value);\n', '        uint256 _principle = _value.sub(_fee);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_principle);\n', '        emit Transfer(_from, _to, _principle);\n', '        emit Transfer(_from, feeRecipient, _fee);\n', '        if (_fee > 0) {\n', '            balances[feeRecipient] = balances[feeRecipient].add(_fee);\n', '            emit FeeCollected(_from, feeRecipient, _fee);\n', '        }\n', '\n', '        return _principle;\n', '    }\n', '\n', '    // OWNER FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "onlyOwner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to begin transferring control of the contract to a proposedOwner\n', '     * @param _proposedOwner The address to transfer ownership to.\n', '     */\n', '    function proposeOwner(address _proposedOwner) public onlyOwner {\n', '        require(_proposedOwner != address(0), "cannot transfer ownership to address zero");\n', '        require(msg.sender != _proposedOwner, "caller already is owner");\n', '        proposedOwner = _proposedOwner;\n', '        emit OwnershipTransferProposed(owner, proposedOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner or proposed owner to cancel transferring control of the contract to a proposedOwner\n', '     */\n', '    function disregardProposeOwner() public {\n', '        require(msg.sender == proposedOwner || msg.sender == owner, "only proposedOwner or owner");\n', '        require(proposedOwner != address(0), "can only disregard a proposed owner that was previously set");\n', '        address _oldProposedOwner = proposedOwner;\n', '        proposedOwner = address(0);\n', '        emit OwnershipTransferDisregarded(_oldProposedOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the proposed owner to complete transferring control of the contract to the proposedOwner.\n', '     */\n', '    function claimOwnership() public {\n', '        require(msg.sender == proposedOwner, "onlyProposedOwner");\n', '        address _oldOwner = owner;\n', '        owner = proposedOwner;\n', '        proposedOwner = address(0);\n', '        emit OwnershipTransferred(_oldOwner, owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Reclaim all MTW at the contract address.\n', '     * This sends the MTW tokens that this contract add holding to the owner.\n', '     * Note: this is not affected by freeze constraints.\n', '     */\n', '    function reclaimMTW() external onlyOwner {\n', '        uint256 _balance = balances[address(this)];\n', '        balances[address(this)] = 0;\n', '        balances[owner] = balances[owner].add(_balance);\n', '        emit Transfer(address(this), owner, _balance);\n', '    }\n', '\n', '    // PAUSABILITY FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused, "whenNotPaused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyOwner {\n', '        require(!paused, "already paused");\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyOwner {\n', '        require(paused, "already unpaused");\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    // ASSET PROTECTION FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Sets a new asset protection role address.\n', '     * @param _newAssetProtectionRole The new address allowed to freeze/unfreeze addresses and seize their tokens.\n', '     */\n', '    function setAssetProtectionRole(address _newAssetProtectionRole) public {\n', '        require(msg.sender == assetProtectionRole || msg.sender == owner, "only assetProtectionRole or Owner");\n', '        emit AssetProtectionRoleSet(assetProtectionRole, _newAssetProtectionRole);\n', '        assetProtectionRole = _newAssetProtectionRole;\n', '    }\n', '\n', '    modifier onlyAssetProtectionRole() {\n', '        require(msg.sender == assetProtectionRole, "onlyAssetProtectionRole");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Freezes an address balance from being transferred.\n', '     * @param _addr The new address to freeze.\n', '     */\n', '    function freeze(address _addr) public onlyAssetProtectionRole {\n', '        require(!frozen[_addr], "address already frozen");\n', '        frozen[_addr] = true;\n', '        emit AddressFrozen(_addr);\n', '    }\n', '\n', '    /**\n', '     * @dev Unfreezes an address balance allowing transfer.\n', '     * @param _addr The new address to unfreeze.\n', '     */\n', '    function unfreeze(address _addr) public onlyAssetProtectionRole {\n', '        require(frozen[_addr], "address already unfrozen");\n', '        frozen[_addr] = false;\n', '        emit AddressUnfrozen(_addr);\n', '    }\n', '\n', '    /**\n', '     * @dev Wipes the balance of a frozen address, burning the tokens\n', '     * and setting the approval to zero.\n', '     * @param _addr The new frozen address to wipe.\n', '     */\n', '    function wipeFrozenAddress(address _addr) public onlyAssetProtectionRole {\n', '        require(frozen[_addr], "address is not frozen");\n', '        uint256 _balance = balances[_addr];\n', '        balances[_addr] = 0;\n', '        totalSupply_ = totalSupply_.sub(_balance);\n', '        emit FrozenAddressWiped(_addr);\n', '        emit SupplyDecreased(_addr, _balance);\n', '        emit Transfer(_addr, address(0), _balance);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets whether the address is currently frozen.\n', '    * @param _addr The address to check if frozen.\n', '    * @return A bool representing whether the given address is frozen.\n', '    */\n', '    function isFrozen(address _addr) public view returns (bool) {\n', '        return frozen[_addr];\n', '    }\n', '\n', '    // SUPPLY CONTROL FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Sets a new supply controller address.\n', '     * @param _newSupplyController The address allowed to burn/mint tokens to control supply.\n', '     */\n', '    function setSupplyController(address _newSupplyController) public {\n', '        require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");\n', '        require(_newSupplyController != address(0), "cannot set supply controller to address zero");\n', '        emit SupplyControllerSet(supplyController, _newSupplyController);\n', '        supplyController = _newSupplyController;\n', '    }\n', '\n', '    modifier onlySupplyController() {\n', '        require(msg.sender == supplyController, "onlySupplyController");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.\n', '     * @param _value The number of tokens to add.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {\n', '        totalSupply_ = totalSupply_.add(_value);\n', '        balances[supplyController] = balances[supplyController].add(_value);\n', '        emit SupplyIncreased(supplyController, _value);\n', '        emit Transfer(address(0), supplyController, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decreases the total supply by burning the specified number of tokens from the supply controller account.\n', '     * @param _value The number of tokens to remove.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {\n', '        require(_value <= balances[supplyController], "not enough supply");\n', '        balances[supplyController] = balances[supplyController].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit SupplyDecreased(supplyController, _value);\n', '        emit Transfer(supplyController, address(0), _value);\n', '        return true;\n', '    }\n', '\n', '    // DELEGATED TRANSFER FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev returns the next seq for a target address.\n', '     * The transactor must submit nextSeqOf(transactor) in the next transaction for it to be valid.\n', '     * Note: that the seq context is specific to this smart contract.\n', '     * @param target The target address.\n', '     * @return the seq.\n', '     */\n', '    //\n', '    function nextSeqOf(address target) public view returns (uint256) {\n', '        return nextSeqs[target];\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a transfer on behalf of the from address, identified by its signature on the delegatedTransfer msg.\n', '     * Splits a signature byte array into r,s,v for convenience.\n', '     * @param sig the signature of the delgatedTransfer msg.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @param serviceFee an optional ERC20 service fee paid to the executor of betaDelegatedTransfer by the from address.\n', '     * @param seq a sequencing number included by the from address specific to this contract to protect from replays.\n', '     * @param deadline a block number after which the pre-signed transaction has expired.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function betaDelegatedTransfer(\n', '        bytes memory sig, address to, uint256 value, uint256 serviceFee, uint256 seq, uint256 deadline\n', '    ) public returns (bool) {\n', '        require(sig.length == 65, "signature should have length 65");\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '        require(_betaDelegatedTransfer(r, s, v, to, value, serviceFee, seq, deadline), "failed transfer");\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a transfer on behalf of the from address, identified by its signature on the betaDelegatedTransfer msg.\n', '     * Note: both the delegate and transactor sign in the service fees. The transactor, however,\n', '     * has no control over the gas price, and therefore no control over the transaction time.\n', '     * Beta prefix chosen to avoid a name clash with an emerging standard in ERC865 or elsewhere.\n', '     * Internal to the contract - see betaDelegatedTransfer and betaDelegatedTransferBatch.\n', '     * @param r the r signature of the delgatedTransfer msg.\n', '     * @param s the s signature of the delgatedTransfer msg.\n', '     * @param v the v signature of the delgatedTransfer msg.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @param serviceFee an optional ERC20 service fee paid to the delegate of betaDelegatedTransfer by the from address.\n', '     * @param seq a sequencing number included by the from address specific to this contract to protect from replays.\n', '     * @param deadline a block number after which the pre-signed transaction has expired.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function _betaDelegatedTransfer(\n', '        bytes32 r, bytes32 s, uint8 v, address to, uint256 value, uint256 serviceFee, uint256 seq, uint256 deadline\n', '    ) internal whenNotPaused returns (bool) {\n', '        require(betaDelegateWhitelist[msg.sender], "Beta feature only accepts whitelisted delegates");\n', '        require(value > 0 || serviceFee > 0, "cannot transfer zero tokens with zero service fee");\n', '        require(block.number <= deadline, "transaction expired");\n', '        // prevent sig malleability from ecrecover()\n', '        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "signature incorrect");\n', '        require(v == 27 || v == 28, "signature incorrect");\n', '\n', '        // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md\n', '        bytes32 hash = keccak256(abi.encodePacked(\n', '            EIP191_HEADER, EIP712_DOMAIN_HASH, keccak256(abi.encodePacked(// solium-disable-line\n', '              EIP712_DELEGATED_TRANSFER_SCHEMA_HASH, bytes32(uint256(to)), value, serviceFee, seq, deadline))));\n', '        address _from = ecrecover(hash, v, r, s);\n', '\n', '        require(_from != address(0), "error determining from address from signature");\n', '        require(to != address(0), "cannot use address zero");\n', '        require(!frozen[to] && !frozen[_from] && !frozen[msg.sender], "address frozen");\n', '        require(value.add(serviceFee) <= balances[_from], "insufficient funds or bad signature");\n', '        require(nextSeqs[_from] == seq, "incorrect seq");\n', '\n', '        nextSeqs[_from] = nextSeqs[_from].add(1);\n', '\n', '        uint256 _principle = _transfer(_from, to, value);\n', '\n', '        if (serviceFee != 0) {\n', '            balances[_from] = balances[_from].sub(serviceFee);\n', '            balances[msg.sender] = balances[msg.sender].add(serviceFee);\n', '            emit Transfer(_from, msg.sender, serviceFee);\n', '        }\n', '\n', '        emit BetaDelegatedTransfer(_from, to, _principle, seq, serviceFee);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Performs an atomic batch of transfers on behalf of the from addresses, identified by their signatures.\n', '     * Lack of nested array support in arguments requires all arguments to be passed as equal size arrays where\n', '     * delegated transfer number i is the combination of all arguments at index i\n', '     * @param r the r signatures of the delgatedTransfer msg.\n', '     * @param s the s signatures of the delgatedTransfer msg.\n', '     * @param v the v signatures of the delgatedTransfer msg.\n', '     * @param to The addresses to transfer to.\n', '     * @param value The amounts to be transferred.\n', '     * @param serviceFee optional ERC20 service fees paid to the delegate of betaDelegatedTransfer by the from address.\n', '     * @param seq sequencing numbers included by the from address specific to this contract to protect from replays.\n', '     * @param deadline block numbers after which the pre-signed transactions have expired.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function betaDelegatedTransferBatch(\n', '        bytes32[] memory r, \n', '        bytes32[] memory s, \n', '        uint8[] memory v, \n', '        address[] memory to, \n', '        uint256[] memory value, \n', '        uint256[] memory serviceFee, \n', '        uint256[] memory seq, \n', '        uint256[] memory deadline\n', '    ) public returns (bool) {\n', '        require(r.length == s.length && r.length == v.length && r.length == to.length && r.length == value.length, "length mismatch");\n', '        require(r.length == serviceFee.length && r.length == seq.length && r.length == deadline.length, "length mismatch");\n', '\n', '        for (uint i = 0; i < r.length; i++) {\n', '            require(\n', '                _betaDelegatedTransfer(r[i], s[i], v[i], to[i], value[i], serviceFee[i], seq[i], deadline[i]),\n', '                "failed transfer"\n', '            );\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets whether the address is currently whitelisted for betaDelegateTransfer.\n', '    * @param _addr The address to check if whitelisted.\n', '    * @return A bool representing whether the given address is whitelisted.\n', '    */\n', '    function isWhitelistedBetaDelegate(address _addr) public view returns (bool) {\n', '        return betaDelegateWhitelist[_addr];\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new betaDelegate whitelister.\n', '     * @param _newWhitelister The address allowed to whitelist betaDelegates.\n', '     */\n', '    function setBetaDelegateWhitelister(address _newWhitelister) public {\n', '        require(msg.sender == betaDelegateWhitelister || msg.sender == owner, "only Whitelister or Owner");\n', '        betaDelegateWhitelister = _newWhitelister;\n', '        emit BetaDelegateWhitelisterSet(betaDelegateWhitelister, _newWhitelister);\n', '    }\n', '\n', '    modifier onlyBetaDelegateWhitelister() {\n', '        require(msg.sender == betaDelegateWhitelister, "onlyBetaDelegateWhitelister");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Whitelists an address to allow calling BetaDelegatedTransfer.\n', '     * @param _addr The new address to whitelist.\n', '     */\n', '    function whitelistBetaDelegate(address _addr) public onlyBetaDelegateWhitelister {\n', '        require(!betaDelegateWhitelist[_addr], "delegate already whitelisted");\n', '        betaDelegateWhitelist[_addr] = true;\n', '        emit BetaDelegateWhitelisted(_addr);\n', '    }\n', '\n', '    /**\n', '     * @dev Unwhitelists an address to disallow calling BetaDelegatedTransfer.\n', '     * @param _addr The new address to whitelist.\n', '     */\n', '    function unwhitelistBetaDelegate(address _addr) public onlyBetaDelegateWhitelister {\n', '        require(betaDelegateWhitelist[_addr], "delegate not whitelisted");\n', '        betaDelegateWhitelist[_addr] = false;\n', '        emit BetaDelegateUnwhitelisted(_addr);\n', '    }\n', '\n', '    // FEE CONTROLLER FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Sets a new fee controller address.\n', '     * @param _newFeeController The address allowed to set the fee rate and the fee recipient.\n', '     */\n', '    function setFeeController(address _newFeeController) public {\n', '        require(msg.sender == feeController || msg.sender == owner, "only FeeController or Owner");\n', '        require(_newFeeController != address(0), "cannot set fee controller to address zero");\n', '        address _oldFeeController = feeController;\n', '        feeController = _newFeeController;\n', '        emit FeeControllerSet(_oldFeeController, feeController);\n', '    }\n', '\n', '    modifier onlyFeeController() {\n', '        require(msg.sender == feeController, "only FeeController");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new fee recipient address.\n', '     * @param _newFeeRecipient The address allowed to collect transfer fees for transfers.\n', '     */\n', '    function setFeeRecipient(address _newFeeRecipient) public onlyFeeController {\n', '        require(_newFeeRecipient != address(0), "cannot set fee recipient to address zero");\n', '        address _oldFeeRecipient = feeRecipient;\n', '        feeRecipient = _newFeeRecipient;\n', '        emit FeeRecipientSet(_oldFeeRecipient, feeRecipient);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new fee rate.\n', '     * @param _newFeeRate The new fee rate to collect as transfer fees for transfers.\n', '     */\n', '    function setFeeRate(uint256 _newFeeRate) public onlyFeeController {\n', '        require(_newFeeRate <= feeParts, "cannot set fee rate above 100%");\n', '        uint256 _oldFeeRate = feeRate;\n', '        feeRate = _newFeeRate;\n', '        emit FeeRateSet(_oldFeeRate, feeRate);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets a fee for a given value\n', '    * ex: given feeRate = 200 and feeParts = 1,000,000 then getFeeFor(10000) = 2\n', '    * @param _value The amount to get the fee for.\n', '    */\n', '    function getFeeFor(uint256 _value) public view returns (uint256) {\n', '        if (feeRate == 0) {\n', '            return 0;\n', '        }\n', '\n', '        return _value.mul(feeRate).div(feeParts);\n', '    }\n', '}']