['pragma solidity ^0.4.22;\n', '\n', '// Generated by TokenGen and the Fabric Token platform.\n', '// https://tokengen.io\n', '// https://fabrictoken.io\n', '\n', '// File: contracts/library/SafeMath.sol\n', '\n', '/**\n', ' * @title Safe Math\n', ' *\n', ' * @dev Library for safe mathematical operations.\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function minus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    function plus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/token/ERC20Token.sol\n', '\n', '/**\n', ' * @dev The standard ERC20 Token contract base.\n', ' */\n', 'contract ERC20Token {\n', '    uint256 public totalSupply;  /* shorthand for public function and a property */\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/component/TokenSafe.sol\n', '\n', '/**\n', ' * @title TokenSafe\n', ' *\n', ' * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group\n', " *      has it's own release time and multiple accounts with locked tokens.\n", ' */\n', 'contract TokenSafe {\n', '    using SafeMath for uint;\n', '\n', '    // The ERC20 token contract.\n', '    ERC20Token token;\n', '\n', '    struct Group {\n', '        // The release date for the locked tokens\n', '        // Note: Unix timestamp fits in uint32, however block.timestamp is uint256\n', '        uint256 releaseTimestamp;\n', '        // The total remaining tokens in the group.\n', '        uint256 remaining;\n', '        // The individual account token balances in the group.\n', '        mapping (address => uint) balances;\n', '    }\n', '\n', '    // The groups of locked tokens\n', '    mapping (uint8 => Group) public groups;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     * @param _token The address of the Fabric Token (fundraiser) contract.\n', '     */\n', '    constructor(address _token) public {\n', '        token = ERC20Token(_token);\n', '    }\n', '\n', '    /**\n', '     * @dev The function initializes a group with a release date.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released\n', '     */\n', '    function init(uint8 _id, uint _releaseTimestamp) internal {\n', '        require(_releaseTimestamp > 0, "TokenSafe group release timestamp is not set");\n', '        \n', '        Group storage group = groups[_id];\n', '        group.releaseTimestamp = _releaseTimestamp;\n', '    }\n', '\n', '    /**\n', '     * @dev Add new account with locked token balance to the specified group id.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _account The address of the account to be added.\n', '     * @param _balance The number of tokens to be locked.\n', '     */\n', '    function add(uint8 _id, address _account, uint _balance) internal {\n', '        Group storage group = groups[_id];\n', '        group.balances[_account] = group.balances[_account].plus(_balance);\n', '        group.remaining = group.remaining.plus(_balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows an account to be released if it meets the time constraints of the group.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _account The address of the account to be released.\n', '     */\n', '    function release(uint8 _id, address _account) public {\n', '        Group storage group = groups[_id];\n', '        require(now >= group.releaseTimestamp, "Group funds are not released yet");\n', '        \n', '        uint tokens = group.balances[_account];\n', '        require(tokens > 0, "The account is empty or non-existent");\n', '        \n', '        group.balances[_account] = 0;\n', '        group.remaining = group.remaining.minus(tokens);\n', '        \n', '        if (!token.transfer(_account, tokens)) {\n', '            revert("Token transfer failed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard Token\n', ' *\n', ' * @dev The standard abstract implementation of the ERC20 interface.\n', ' */\n', 'contract StandardToken is ERC20Token {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev The constructor assigns the token name, symbols and decimals.\n', '     */\n', '    constructor(string _name, string _symbol, uint8 _decimals) internal {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the balance of an address.\n', '     *\n', "     * @param _address The address which's balance will be checked.\n", '     *\n', '     * @return The current balance of the address.\n', '     */\n', '    function balanceOf(address _address) public view returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '\n', '    /**\n', '     * @dev Checks the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * @param _owner The address which owns the funds allowed for spending by a third-party.\n', '     * @param _spender The third-party address that is allowed to spend the tokens.\n', '     *\n', '     * @return The number of tokens available to `_spender` to be spent.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.\n', '     * E.g. You place a buy or sell order on an exchange and in that example, the \n', '     * `_spender` address is the address of the contract the exchange created to add your token to their \n', '     * website and you are `msg.sender`.\n', '     *\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     *\n', '     * @return Whether the approval process was successful or not.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers `_value` number of tokens to the `_to` address.\n', '     *\n', '     * @param _to The address of the recipient.\n', '     * @param _value The number of tokens to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        executeTransfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.\n', '     *\n', '     * @param _from The address which approved you to spend tokens on their behalf.\n', '     * @param _to The address where you want to send tokens.\n', '     * @param _value The number of tokens to be sent.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);\n', '        executeTransfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that this reused by the transfer functions\n', '     */\n', '    function executeTransfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0), "Invalid transfer to address zero");\n', '        require(_value <= balances[_from], "Insufficient account balance");\n', '\n', '        balances[_from] = balances[_from].minus(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '}\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable Token\n', ' *\n', ' * @dev Allows the creation of new tokens.\n', ' */\n', 'contract MintableToken is StandardToken {\n', '    /// @dev The only address allowed to mint coins\n', '    address public minter;\n', '\n', '    /// @dev Indicates whether the token is still mintable.\n', '    bool public mintingDisabled = false;\n', '\n', '    /**\n', '     * @dev Event fired when minting is no longer allowed.\n', '     */\n', '    event MintingDisabled();\n', '\n', '    /**\n', '     * @dev Allows a function to be executed only if minting is still allowed.\n', '     */\n', '    modifier canMint() {\n', '        require(!mintingDisabled, "Minting is disabled");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows a function to be called only by the minter\n', '     */\n', '    modifier onlyMinter() {\n', '        require(msg.sender == minter, "Only the minter address can mint");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The constructor assigns the minter which is allowed to mind and disable minting\n', '     */\n', '    constructor(address _minter) internal {\n', '        minter = _minter;\n', '    }\n', '\n', '    /**\n', '    * @dev Creates new `_value` number of tokens and sends them to the `_to` address.\n', '    *\n', '    * @param _to The address which will receive the freshly minted tokens.\n', '    * @param _value The number of tokens that will be created.\n', '    */\n', '    function mint(address _to, uint256 _value) public onlyMinter canMint {\n', '        totalSupply = totalSupply.plus(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '\n', '        emit Transfer(0x0, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Disable the minting of new tokens. Cannot be reversed.\n', '    *\n', '    * @return Whether or not the process was successful.\n', '    */\n', '    function disableMinting() public onlyMinter canMint {\n', '        mintingDisabled = true;\n', '       \n', '        emit MintingDisabled();\n', '    }\n', '}\n', '\n', '// File: contracts/trait/HasOwner.sol\n', '\n', '/**\n', ' * @title HasOwner\n', ' *\n', ' * @dev Allows for exclusive access to certain functionality.\n', ' */\n', 'contract HasOwner {\n', '    // The current owner.\n', '    address public owner;\n', '\n', '    // Conditionally the new owner.\n', '    address public newOwner;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     * @param _owner The address of the owner.\n', '     */\n', '    constructor(address _owner) public {\n', '        owner = _owner;\n', '    }\n', '\n', '    /** \n', '     * @dev Access control modifier that allows only the current owner to call the function.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Only owner can call this function");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The event is fired when the current owner is changed.\n', '     *\n', '     * @param _oldOwner The address of the previous owner.\n', '     * @param _newOwner The address of the new owner.\n', '     */\n', '    event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);\n', '\n', '    /**\n', '     * @dev Transfering the ownership is a two-step process, as we prepare\n', '     * for the transfer by setting `newOwner` and requiring `newOwner` to accept\n', '     * the transfer. This prevents accidental lock-out if something goes wrong\n', '     * when passing the `newOwner` address.\n', '     *\n', '     * @param _newOwner The address of the proposed new owner.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', ' \n', '    /**\n', '     * @dev The `newOwner` finishes the ownership transfer process by accepting the\n', '     * ownership.\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner, "Only the newOwner can accept ownership");\n', '\n', '        emit OwnershipTransfer(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/AbstractFundraiser.sol\n', '\n', 'contract AbstractFundraiser {\n', '    /// The ERC20 token contract.\n', '    ERC20Token public token;\n', '\n', '    /**\n', '     * @dev The event fires every time a new buyer enters the fundraiser.\n', '     *\n', '     * @param _address The address of the buyer.\n', '     * @param _ethers The number of ethers funded.\n', '     * @param _tokens The number of tokens purchased.\n', '     */\n', '    event FundsReceived(address indexed _address, uint _ethers, uint _tokens);\n', '\n', '\n', '    /**\n', '     * @dev The initialization method for the token\n', '     *\n', '     * @param _token The address of the token of the fundraiser\n', '     */\n', '    function initializeFundraiserToken(address _token) internal\n', '    {\n', '        token = ERC20Token(_token);\n', '    }\n', '\n', '    /**\n', '     * @dev The default function which is executed when someone sends funds to this contract address.\n', '     */\n', '    function() public payable {\n', '        receiveFunds(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @dev this overridable function returns the current conversion rate for the fundraiser\n', '     */\n', '    function getConversionRate() public view returns (uint256);\n', '\n', '    /**\n', '     * @dev checks whether the fundraiser passed `endTime`.\n', '     *\n', '     * @return whether the fundraiser has ended.\n', '     */\n', '    function hasEnded() public view returns (bool);\n', '\n', '    /**\n', '     * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.\n', '     *\n', '     * @param _address The address of the receiver of tokens.\n', '     * @param _amount The amount of received funds in ether.\n', '     */\n', '    function receiveFunds(address _address, uint256 _amount) internal;\n', '    \n', '    /**\n', '     * @dev It throws an exception if the transaction does not meet the preconditions.\n', '     */\n', '    function validateTransaction() internal view;\n', '    \n', '    /**\n', '     * @dev this overridable function makes and handles tokens to buyers\n', '     */\n', '    function handleTokens(address _address, uint256 _tokens) internal;\n', '\n', '    /**\n', '     * @dev this overridable function forwards the funds (if necessary) to a vault or directly to the beneficiary\n', '     */\n', '    function handleFunds(address _address, uint256 _ethers) internal;\n', '\n', '}\n', '\n', '// File: contracts/fundraiser/BasicFundraiser.sol\n', '\n', '/**\n', ' * @title Basic Fundraiser\n', ' *\n', ' * @dev An abstract contract that is a base for fundraisers. \n', ' * It implements a generic procedure for handling received funds:\n', ' * 1. Validates the transaction preconditions\n', ' * 2. Calculates the amount of tokens based on the conversion rate.\n', ' * 3. Delegate the handling of the tokens (mint, transfer or create)\n', ' * 4. Delegate the handling of the funds\n', ' * 5. Emit event for received funds\n', ' */\n', 'contract BasicFundraiser is HasOwner, AbstractFundraiser {\n', '    using SafeMath for uint256;\n', '\n', '    // The number of decimals for the token.\n', '    uint8 constant DECIMALS = 18;  // Enforced\n', '\n', '    // Decimal factor for multiplication purposes.\n', '    uint256 constant DECIMALS_FACTOR = 10 ** uint256(DECIMALS);\n', '\n', '    // The start time of the fundraiser - Unix timestamp.\n', '    uint256 public startTime;\n', '\n', '    // The end time of the fundraiser - Unix timestamp.\n', '    uint256 public endTime;\n', '\n', '    // The address where funds collected will be sent.\n', '    address public beneficiary;\n', '\n', '    // The conversion rate with decimals difference adjustment,\n', '    // When converion rate is lower than 1 (inversed), the function calculateTokens() should use division\n', '    uint256 public conversionRate;\n', '\n', '    // The total amount of ether raised.\n', '    uint256 public totalRaised;\n', '\n', '    /**\n', '     * @dev The event fires when the number of token conversion rate has changed.\n', '     *\n', '     * @param _conversionRate The new number of tokens per 1 ether.\n', '     */\n', '    event ConversionRateChanged(uint _conversionRate);\n', '\n', '    /**\n', '     * @dev The basic fundraiser initialization method.\n', '     *\n', '     * @param _startTime The start time of the fundraiser - Unix timestamp.\n', '     * @param _endTime The end time of the fundraiser - Unix timestamp.\n', '     * @param _conversionRate The number of tokens create for 1 ETH funded.\n', '     * @param _beneficiary The address which will receive the funds gathered by the fundraiser.\n', '     */\n', '    function initializeBasicFundraiser(\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _conversionRate,\n', '        address _beneficiary\n', '    )\n', '        internal\n', '    {\n', '        require(_endTime >= _startTime, "Fundraiser\'s end is before its start");\n', '        require(_conversionRate > 0, "Conversion rate is not set");\n', '        require(_beneficiary != address(0), "The beneficiary is not set");\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        conversionRate = _conversionRate;\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the new conversion rate\n', '     *\n', '     * @param _conversionRate New conversion rate\n', '     */\n', '    function setConversionRate(uint256 _conversionRate) public onlyOwner {\n', '        require(_conversionRate > 0, "Conversion rate is not set");\n', '\n', '        conversionRate = _conversionRate;\n', '\n', '        emit ConversionRateChanged(_conversionRate);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets The beneficiary of the fundraiser.\n', '     *\n', '     * @param _beneficiary The address of the beneficiary.\n', '     */\n', '    function setBeneficiary(address _beneficiary) public onlyOwner {\n', '        require(_beneficiary != address(0), "The beneficiary is not set");\n', '\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.\n', '     *\n', '     * @param _address The address of the receiver of tokens.\n', '     * @param _amount The amount of received funds in ether.\n', '     */\n', '    function receiveFunds(address _address, uint256 _amount) internal {\n', '        validateTransaction();\n', '\n', '        uint256 tokens = calculateTokens(_amount);\n', '        require(tokens > 0, "The transaction results in zero tokens");\n', '\n', '        totalRaised = totalRaised.plus(_amount);\n', '        handleTokens(_address, tokens);\n', '        handleFunds(_address, _amount);\n', '\n', '        emit FundsReceived(_address, msg.value, tokens);\n', '    }\n', '\n', '    /**\n', '     * @dev this overridable function returns the current conversion rate multiplied by the conversion rate factor\n', '     */\n', '    function getConversionRate() public view returns (uint256) {\n', '        return conversionRate;\n', '    }\n', '\n', '    /**\n', '     * @dev this overridable function that calculates the tokens based on the ether amount\n', '     */\n', '    function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {\n', '        tokens = _amount.mul(getConversionRate());\n', '    }\n', '\n', '    /**\n', '     * @dev It throws an exception if the transaction does not meet the preconditions.\n', '     */\n', '    function validateTransaction() internal view {\n', '        require(msg.value != 0, "Transaction value is zero");\n', '        require(now >= startTime && now < endTime, "The fundraiser is not active");\n', '    }\n', '\n', '    /**\n', '     * @dev checks whether the fundraiser passed `endtime`.\n', '     *\n', '     * @return whether the fundraiser is passed its deadline or not.\n', '     */\n', '    function hasEnded() public view returns (bool) {\n', '        return now >= endTime;\n', '    }\n', '}\n', '\n', '// File: contracts/token/StandardMintableToken.sol\n', '\n', 'contract StandardMintableToken is MintableToken {\n', '    constructor(address _minter, string _name, string _symbol, uint8 _decimals)\n', '        StandardToken(_name, _symbol, _decimals)\n', '        MintableToken(_minter)\n', '        public\n', '    {\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/MintableTokenFundraiser.sol\n', '\n', '/**\n', ' * @title Fundraiser With Mintable Token\n', ' */\n', 'contract MintableTokenFundraiser is BasicFundraiser {\n', '    /**\n', '     * @dev The initialization method that creates a new mintable token.\n', '     *\n', '     * @param _name Token name\n', '     * @param _symbol Token symbol\n', '     * @param _decimals Token decimals\n', '     */\n', '    function initializeMintableTokenFundraiser(string _name, string _symbol, uint8 _decimals) internal {\n', '        token = new StandardMintableToken(\n', '            address(this), // The fundraiser is the token minter\n', '            _name,\n', '            _symbol,\n', '            _decimals\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Mint the specific amount tokens\n', '     */\n', '    function handleTokens(address _address, uint256 _tokens) internal {\n', '        MintableToken(token).mint(_address, _tokens);\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/IndividualCapsFundraiser.sol\n', '\n', '/**\n', ' * @title Fundraiser with individual caps\n', ' *\n', ' * @dev Allows you to set a hard cap on your fundraiser.\n', ' */\n', 'contract IndividualCapsFundraiser is BasicFundraiser {\n', '    uint256 public individualMinCap;\n', '    uint256 public individualMaxCap;\n', '    uint256 public individualMaxCapTokens;\n', '\n', '\n', '    event IndividualMinCapChanged(uint256 _individualMinCap);\n', '    event IndividualMaxCapTokensChanged(uint256 _individualMaxCapTokens);\n', '\n', '    /**\n', '     * @dev The initialization method.\n', '     *\n', '     * @param _individualMinCap The minimum amount of ether contribution per address.\n', '     * @param _individualMaxCap The maximum amount of ether contribution per address.\n', '     */\n', '    function initializeIndividualCapsFundraiser(uint256 _individualMinCap, uint256 _individualMaxCap) internal {\n', '        individualMinCap = _individualMinCap;\n', '        individualMaxCap = _individualMaxCap;\n', '        individualMaxCapTokens = _individualMaxCap * conversionRate;\n', '    }\n', '\n', '    function setConversionRate(uint256 _conversionRate) public onlyOwner {\n', '        super.setConversionRate(_conversionRate);\n', '\n', '        if (individualMaxCap == 0) {\n', '            return;\n', '        }\n', '        \n', '        individualMaxCapTokens = individualMaxCap * _conversionRate;\n', '\n', '        emit IndividualMaxCapTokensChanged(individualMaxCapTokens);\n', '    }\n', '\n', '    function setIndividualMinCap(uint256 _individualMinCap) public onlyOwner {\n', '        individualMinCap = _individualMinCap;\n', '\n', '        emit IndividualMinCapChanged(individualMinCap);\n', '    }\n', '\n', '    function setIndividualMaxCap(uint256 _individualMaxCap) public onlyOwner {\n', '        individualMaxCap = _individualMaxCap;\n', '        individualMaxCapTokens = _individualMaxCap * conversionRate;\n', '\n', '        emit IndividualMaxCapTokensChanged(individualMaxCapTokens);\n', '    }\n', '\n', '    /**\n', '     * @dev Extends the transaction validation to check if the value is higher than the minimum cap.\n', '     */\n', '    function validateTransaction() internal view {\n', '        super.validateTransaction();\n', '        require(\n', '            msg.value >= individualMinCap,\n', '            "The transaction value does not pass the minimum contribution cap"\n', '        );\n', '    }\n', '\n', '    /**\n', "     * @dev We validate the new amount doesn't surpass maximum contribution cap\n", '     */\n', '    function handleTokens(address _address, uint256 _tokens) internal {\n', '        require(\n', '            individualMaxCapTokens == 0 || token.balanceOf(_address).plus(_tokens) <= individualMaxCapTokens,\n', '            "The transaction exceeds the individual maximum cap"\n', '        );\n', '\n', '        super.handleTokens(_address, _tokens);\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/GasPriceLimitFundraiser.sol\n', '\n', '/**\n', ' * @title GasPriceLimitFundraiser\n', ' *\n', ' * @dev This fundraiser allows to set gas price limit for the participants in the fundraiser\n', ' */\n', 'contract GasPriceLimitFundraiser is HasOwner, BasicFundraiser {\n', '    uint256 public gasPriceLimit;\n', '\n', '    event GasPriceLimitChanged(uint256 gasPriceLimit);\n', '\n', '    /**\n', '     * @dev This function puts the initial gas limit\n', '     */\n', '    function initializeGasPriceLimitFundraiser(uint256 _gasPriceLimit) internal {\n', '        gasPriceLimit = _gasPriceLimit;\n', '    }\n', '\n', '    /**\n', '     * @dev This function allows the owner to change the gas limit any time during the fundraiser\n', '     */\n', '    function changeGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {\n', '        gasPriceLimit = _gasPriceLimit;\n', '\n', '        emit GasPriceLimitChanged(_gasPriceLimit);\n', '    }\n', '\n', '    /**\n', '     * @dev The transaction is valid if the gas price limit is lifted-off or the transaction meets the requirement\n', '     */\n', '    function validateTransaction() internal view {\n', '        require(gasPriceLimit == 0 || tx.gasprice <= gasPriceLimit, "Transaction exceeds the gas price limit");\n', '\n', '        return super.validateTransaction();\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/ForwardFundsFundraiser.sol\n', '\n', '/**\n', ' * @title Forward Funds to Beneficiary Fundraiser\n', ' *\n', ' * @dev This contract forwards the funds received to the beneficiary.\n', ' */\n', 'contract ForwardFundsFundraiser is BasicFundraiser {\n', '    /**\n', '     * @dev Forward funds directly to beneficiary\n', '     */\n', '    function handleFunds(address, uint256 _ethers) internal {\n', '        // Forward the funds directly to the beneficiary\n', '        beneficiary.transfer(_ethers);\n', '    }\n', '}\n', '\n', '// File: contracts/fundraiser/PresaleFundraiser.sol\n', '\n', '/**\n', ' * @title PresaleFundraiser\n', ' *\n', ' * @dev This is the standard fundraiser contract which allows\n', ' * you to raise ETH in exchange for your tokens.\n', ' */\n', 'contract PresaleFundraiser is MintableTokenFundraiser {\n', '    /// @dev The token hard cap for the pre-sale\n', '    uint256 public presaleSupply;\n', '\n', '    /// @dev The token hard cap for the pre-sale\n', '    uint256 public presaleMaxSupply;\n', '\n', '    /// @dev The start time of the pre-sale (Unix timestamp).\n', '    uint256 public presaleStartTime;\n', '\n', '    /// @dev The end time of the pre-sale (Unix timestamp).\n', '    uint256 public presaleEndTime;\n', '\n', '    /// @dev The conversion rate for the pre-sale\n', '    uint256 public presaleConversionRate;\n', '\n', '    /**\n', '     * @dev The initialization method.\n', '     *\n', '     * @param _startTime The timestamp of the moment when the pre-sale starts\n', '     * @param _endTime The timestamp of the moment when the pre-sale ends\n', '     * @param _conversionRate The conversion rate during the pre-sale\n', '     */\n', '    function initializePresaleFundraiser(\n', '        uint256 _presaleMaxSupply,\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _conversionRate\n', '    )\n', '        internal\n', '    {\n', '        require(_endTime >= _startTime, "Pre-sale\'s end is before its start");\n', '        require(_conversionRate > 0, "Conversion rate is not set");\n', '\n', '        presaleMaxSupply = _presaleMaxSupply;\n', '        presaleStartTime = _startTime;\n', '        presaleEndTime = _endTime;\n', '        presaleConversionRate = _conversionRate;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal funciton that helps to check if the pre-sale is active\n', '     */\n', '    \n', '    function isPresaleActive() internal view returns (bool) {\n', '        return now < presaleEndTime && now >= presaleStartTime;\n', '    }\n', '    /**\n', '     * @dev this function different conversion rate while in presale\n', '     */\n', '    function getConversionRate() public view returns (uint256) {\n', '        if (isPresaleActive()) {\n', '            return presaleConversionRate;\n', '        }\n', '        return super.getConversionRate();\n', '    }\n', '\n', '    /**\n', '     * @dev It throws an exception if the transaction does not meet the preconditions.\n', '     */\n', '    function validateTransaction() internal view {\n', '        require(msg.value != 0, "Transaction value is zero");\n', '        require(\n', '            now >= startTime && now < endTime || isPresaleActive(),\n', '            "Neither the pre-sale nor the fundraiser are currently active"\n', '        );\n', '    }\n', '\n', '    function handleTokens(address _address, uint256 _tokens) internal {\n', '        if (isPresaleActive()) {\n', '            presaleSupply = presaleSupply.plus(_tokens);\n', '            require(\n', '                presaleSupply <= presaleMaxSupply,\n', '                "Transaction exceeds the pre-sale maximum token supply"\n', '            );\n', '        }\n', '\n', '        super.handleTokens(_address, _tokens);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/fundraiser/TieredFundraiser.sol\n', '\n', '/**\n', ' * @title TieredFundraiser\n', ' *\n', ' * @dev A fundraiser that improves the base conversion precision to allow percent bonuses\n', ' */\n', '\n', 'contract TieredFundraiser is BasicFundraiser {\n', '    // Conversion rate factor for better precision.\n', '    uint256 constant CONVERSION_RATE_FACTOR = 100;\n', '\n', '    /**\n', '      * @dev Define conversion rates based on the tier start and end date\n', '      */\n', '    function getConversionRate() public view returns (uint256) {\n', '        return super.getConversionRate().mul(CONVERSION_RATE_FACTOR);\n', '    }\n', '\n', '    /**\n', '     * @dev this overridable function that calculates the tokens based on the ether amount\n', '     */\n', '    function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {\n', '        return super.calculateTokens(_amount).div(CONVERSION_RATE_FACTOR);\n', '    }\n', '\n', '    /**\n', '     * @dev this overridable function returns the current conversion rate factor\n', '     */\n', '    function getConversionRateFactor() public pure returns (uint256) {\n', '        return CONVERSION_RATE_FACTOR;\n', '    }\n', '}\n', '\n', '// File: contracts/Fundraiser.sol\n', '\n', '/**\n', ' * @title SPACEToken\n', ' */\n', '\n', 'contract SPACEToken is MintableToken {\n', '    constructor(address _minter)\n', '        StandardToken(\n', '            "SPACE",   // Token name\n', '            "SP", // Token symbol\n', '            18  // Token decimals\n', '        )\n', '        \n', '        MintableToken(_minter)\n', '        public\n', '    {\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SPACETokenSafe\n', ' */\n', '\n', 'contract SPACETokenSafe is TokenSafe {\n', '  constructor(address _token)\n', '    TokenSafe(_token)\n', '    public\n', '  {\n', '    \n', '    // Group "Core Team Members and Project Advisors"\n', '    init(\n', '      1, // Group Id\n', '      1553821200 // Release date = 2019-03-29 01:00 UTC\n', '    );\n', '    add(\n', '      1, // Group Id\n', '      0xc5F7f03202c2f85c4d90e89Fc5Ce789c0249Ec26,  // Token Safe Entry Address\n', '      420000000000000000000000  // Allocated tokens\n', '    );\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SPACETokenFundraiser\n', ' */\n', '\n', 'contract SPACETokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, ForwardFundsFundraiser, TieredFundraiser, GasPriceLimitFundraiser {\n', '    SPACETokenSafe public tokenSafe;\n', '\n', '    constructor()\n', '        HasOwner(msg.sender)\n', '        public\n', '    {\n', '        token = new SPACEToken(\n', '        \n', '        address(this)  // The fundraiser is the minter\n', '        );\n', '\n', '        tokenSafe = new SPACETokenSafe(token);\n', '        MintableToken(token).mint(address(tokenSafe), 420000000000000000000000);\n', '\n', '        initializeBasicFundraiser(\n', '            1553731200, // Start date = 2019-03-28 00:00 UTC\n', '            1893455940,  // End date = 2029-12-31 23:59 UTC\n', '            1, // Conversion rate = 1 SP per 1 ether\n', '            0x0dE3D184765E4BCa547B12C5c1786765FE21450b     // Beneficiary\n', '        );\n', '\n', '        initializeIndividualCapsFundraiser(\n', '            (0 ether), // Minimum contribution\n', '            (0 ether)  // Maximum individual cap\n', '        );\n', '\n', '        initializeGasPriceLimitFundraiser(\n', '            3000000000000000 // Gas price limit in wei\n', '        );\n', '\n', '        initializePresaleFundraiser(\n', '            1200000000000000000000000,\n', '            1553558400, // Start = 2019-03-26 00:00 UTC\n', '            1553731140,   // End = 2019-03-27 23:59 UTC\n', '            1\n', '        );\n', '\n', '        \n', '\n', '        \n', '\n', '        \n', '    }\n', '    \n', '    /**\n', '      * @dev Define conversion rates based on the tier start and end date\n', '      */\n', '    function getConversionRate() public view returns (uint256) {\n', '        uint256 rate = super.getConversionRate();\n', '        if (now >= 1553731200 && now < 1556495940)\n', '            return rate.mul(105).div(100);\n', '        \n', '\n', '        return rate;\n', '    }\n', '\n', '    /**\n', '      * @dev Fundraiser with mintable token allows the owner to mint through the Fundraiser contract\n', '      */\n', '    function mint(address _to, uint256 _value) public onlyOwner {\n', '        MintableToken(token).mint(_to, _value);\n', '    }\n', '\n', '    /**\n', '      * @dev Irreversibly disable minting\n', '      */\n', '    function disableMinting() public onlyOwner {\n', '        MintableToken(token).disableMinting();\n', '    }\n', '    \n', '}']