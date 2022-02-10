['pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor(address _owner) public {\n', '        owner = _owner;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    constructor(address _owner) \n', '        public \n', '        Ownable(_owner) \n', '    {\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Validator\n', ' * @dev The Validator contract has a validator address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Validator {\n', '    address public validator;\n', '\n', '    event NewValidatorSet(address indexed previousOwner, address indexed newValidator);\n', '\n', '    /**\n', '    * @dev The Validator constructor sets the original `validator` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        validator = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the validator.\n', '    */\n', '    modifier onlyValidator() {\n', '        require(msg.sender == validator);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current validator to transfer control of the contract to a newValidator.\n', '    * @param newValidator The address to become next validator.\n', '    */\n', '    function setNewValidator(address newValidator) public onlyValidator {\n', '        require(newValidator != address(0));\n', '        emit NewValidatorSet(validator, newValidator);\n', '        validator = newValidator;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', 'contract Whitelist is Ownable {\n', '    mapping(address => bool) internal investorMap;\n', '\n', '    event Approved(address indexed investor);\n', '    event Disapproved(address indexed investor);\n', '\n', '    constructor(address _owner) \n', '        public \n', '        Ownable(_owner) \n', '    {\n', '    }\n', '\n', '    function isInvestorApproved(address _investor) external view returns (bool) {\n', '        require(_investor != address(0));\n', '        return investorMap[_investor];\n', '    }\n', '\n', '    function approveInvestor(address toApprove) external onlyOwner {\n', '        investorMap[toApprove] = true;\n', '        emit Approved(toApprove);\n', '    }\n', '\n', '    function approveInvestorsInBulk(address[] toApprove) external onlyOwner {\n', '        for (uint i = 0; i < toApprove.length; i++) {\n', '            investorMap[toApprove[i]] = true;\n', '            emit Approved(toApprove[i]);\n', '        }\n', '    }\n', '\n', '    function disapproveInvestor(address toDisapprove) external onlyOwner {\n', '        delete investorMap[toDisapprove];\n', '        emit Disapproved(toDisapprove);\n', '    }\n', '\n', '    function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {\n', '        for (uint i = 0; i < toDisapprove.length; i++) {\n', '            delete investorMap[toDisapprove[i]];\n', '            emit Disapproved(toDisapprove[i]);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract CompliantToken is Validator, MintableToken {\n', '    Whitelist public whiteListingContract;\n', '\n', '    struct TransactionStruct {\n', '        address from;\n', '        address to;\n', '        uint256 value;\n', '        uint256 fee;\n', '        address spender;\n', '    }\n', '\n', '    mapping (uint => TransactionStruct) public pendingTransactions;\n', '    mapping (address => mapping (address => uint256)) public pendingApprovalAmount;\n', '    uint256 public currentNonce = 0;\n', '    uint256 public transferFee;\n', '    address public feeRecipient;\n', '\n', '    modifier checkIsInvestorApproved(address _account) {\n', '        require(whiteListingContract.isInvestorApproved(_account));\n', '        _;\n', '    }\n', '\n', '    modifier checkIsAddressValid(address _account) {\n', '        require(_account != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier checkIsValueValid(uint256 _value) {\n', '        require(_value > 0);\n', '        _;\n', '    }\n', '\n', '    event TransferRejected(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value,\n', '        uint256 indexed nonce,\n', '        uint256 reason\n', '    );\n', '\n', '    event TransferWithFee(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value,\n', '        uint256 fee\n', '    );\n', '\n', '    event RecordedPendingTransaction(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value,\n', '        uint256 fee,\n', '        address indexed spender\n', '    );\n', '\n', '    event WhiteListingContractSet(address indexed _whiteListingContract);\n', '\n', '    event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);\n', '\n', '    event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);\n', '\n', '    constructor(\n', '        address _owner,\n', '        address whitelistAddress,\n', '        address recipient,\n', '        uint256 fee\n', '    )\n', '        public \n', '        MintableToken(_owner)\n', '        Validator()\n', '    {\n', '        setWhitelistContract(whitelistAddress);\n', '        setFeeRecipient(recipient);\n', '        setFee(fee);\n', '    }\n', '\n', '    function setWhitelistContract(address whitelistAddress)\n', '        public\n', '        onlyValidator\n', '        checkIsAddressValid(whitelistAddress)\n', '    {\n', '        whiteListingContract = Whitelist(whitelistAddress);\n', '        emit WhiteListingContractSet(whiteListingContract);\n', '    }\n', '\n', '    function setFee(uint256 fee)\n', '        public\n', '        onlyValidator\n', '    {\n', '        emit FeeSet(transferFee, fee);\n', '        transferFee = fee;\n', '    }\n', '\n', '    function setFeeRecipient(address recipient)\n', '        public\n', '        onlyValidator\n', '        checkIsAddressValid(recipient)\n', '    {\n', '        emit FeeRecipientSet(feeRecipient, recipient);\n', '        feeRecipient = recipient;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        checkIsInvestorApproved(msg.sender)\n', '        checkIsInvestorApproved(_to)\n', '        checkIsValueValid(_value)\n', '        returns (bool)\n', '    {\n', '        uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];\n', '\n', '        if (msg.sender == feeRecipient) {\n', '            require(_value.add(pendingAmount) <= balances[msg.sender]);\n', '            pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);\n', '        } else {\n', '            require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);\n', '            pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);\n', '        }\n', '\n', '        pendingTransactions[currentNonce] = TransactionStruct(\n', '            msg.sender,\n', '            _to,\n', '            _value,\n', '            transferFee,\n', '            address(0)\n', '        );\n', '\n', '        emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));\n', '        currentNonce++;\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public \n', '        checkIsInvestorApproved(_from)\n', '        checkIsInvestorApproved(_to)\n', '        checkIsValueValid(_value)\n', '        returns (bool)\n', '    {\n', '        uint256 allowedTransferAmount = allowed[_from][msg.sender];\n', '        uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];\n', '        \n', '        if (_from == feeRecipient) {\n', '            require(_value.add(pendingAmount) <= balances[_from]);\n', '            require(_value.add(pendingAmount) <= allowedTransferAmount);\n', '            pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);\n', '        } else {\n', '            require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);\n', '            require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);\n', '            pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);\n', '        }\n', '\n', '        pendingTransactions[currentNonce] = TransactionStruct(\n', '            _from,\n', '            _to,\n', '            _value,\n', '            transferFee,\n', '            msg.sender\n', '        );\n', '\n', '        emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);\n', '        currentNonce++;\n', '\n', '        return true;\n', '    }\n', '\n', '    function approveTransfer(uint256 nonce)\n', '        external \n', '        onlyValidator \n', '        checkIsInvestorApproved(pendingTransactions[nonce].from)\n', '        checkIsInvestorApproved(pendingTransactions[nonce].to)\n', '        checkIsValueValid(pendingTransactions[nonce].value)\n', '        returns (bool)\n', '    {   \n', '        address from = pendingTransactions[nonce].from;\n', '        address spender = pendingTransactions[nonce].spender;\n', '        address to = pendingTransactions[nonce].to;\n', '        uint256 value = pendingTransactions[nonce].value;\n', '        uint256 allowedTransferAmount = allowed[from][spender];\n', '        uint256 pendingAmount = pendingApprovalAmount[from][spender];\n', '        uint256 fee = pendingTransactions[nonce].fee;\n', '        uint256 balanceFrom = balances[from];\n', '        uint256 balanceTo = balances[to];\n', '\n', '        delete pendingTransactions[nonce];\n', '\n', '        if (from == feeRecipient) {\n', '            fee = 0;\n', '            balanceFrom = balanceFrom.sub(value);\n', '            balanceTo = balanceTo.add(value);\n', '\n', '            if (spender != address(0)) {\n', '                allowedTransferAmount = allowedTransferAmount.sub(value);\n', '            } \n', '            pendingAmount = pendingAmount.sub(value);\n', '\n', '        } else {\n', '            balanceFrom = balanceFrom.sub(value.add(fee));\n', '            balanceTo = balanceTo.add(value);\n', '            balances[feeRecipient] = balances[feeRecipient].add(fee);\n', '\n', '            if (spender != address(0)) {\n', '                allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);\n', '            }\n', '            pendingAmount = pendingAmount.sub(value).sub(fee);\n', '        }\n', '\n', '        emit TransferWithFee(\n', '            from,\n', '            to,\n', '            value,\n', '            fee\n', '        );\n', '\n', '        emit Transfer(\n', '            from,\n', '            to,\n', '            value\n', '        );\n', '        \n', '        balances[from] = balanceFrom;\n', '        balances[to] = balanceTo;\n', '        allowed[from][spender] = allowedTransferAmount;\n', '        pendingApprovalAmount[from][spender] = pendingAmount;\n', '        return true;\n', '    }\n', '\n', '    function rejectTransfer(uint256 nonce, uint256 reason)\n', '        external \n', '        onlyValidator\n', '        checkIsAddressValid(pendingTransactions[nonce].from)\n', '    {        \n', '        address from = pendingTransactions[nonce].from;\n', '        address spender = pendingTransactions[nonce].spender;\n', '\n', '        if (from == feeRecipient) {\n', '            pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]\n', '                .sub(pendingTransactions[nonce].value);\n', '        } else {\n', '            pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]\n', '                .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);\n', '        }\n', '        \n', '        emit TransferRejected(\n', '            from,\n', '            pendingTransactions[nonce].to,\n', '            pendingTransactions[nonce].value,\n', '            nonce,\n', '            reason\n', '        );\n', '        \n', '        delete pendingTransactions[nonce];\n', '    }\n', '}']