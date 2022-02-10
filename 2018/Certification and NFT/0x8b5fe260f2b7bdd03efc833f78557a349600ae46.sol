['pragma solidity ^0.4.19;\n', '\n', '/*\n', '* LooksCoin token sale contract\n', '*\n', '* Refer to https://lookscoin.com for more information.\n', '* \n', '* Developer: LookRev\n', '*\n', '*/\n', '\n', '/*\n', ' * ERC20 Token Standard\n', ' */\n', 'contract ERC20 {\n', 'event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', 'uint256 public totalSupply;\n', 'function balanceOf(address _owner) constant public returns (uint256 balance);\n', 'function transfer(address _to, uint256 _value) public returns (bool success);\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', 'function approve(address _spender, uint256 _value) public returns (bool success);\n', 'function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '}\n', '\n', '/**\n', '* Provides methods to safely add, subtract and multiply uint256 numbers.\n', '*/\n', 'library SafeMath {\n', '    /**\n', '     * Add two uint256 values, revert in case of overflow.\n', '     *\n', '     * @param a first value to add\n', '     * @param b second value to add\n', '     * @return a + b\n', '     */\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Subtract one uint256 value from another, throw in case of underflow.\n', '     *\n', '     * @param a value to subtract from\n', '     * @param b value to subtract\n', '     * @return a - b\n', '     */\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * Multiply two uint256 values, throw in case of overflow.\n', '     *\n', '     * @param a first value to multiply\n', '     * @param b second value to multiply\n', '     * @return a * b\n', '     */\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        if (a == 0 || b == 0) return 0;\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Divid uint256 values, throw in case of overflow.\n', '     *\n', '     * @param a first value numerator\n', '     * @param b second value denominator\n', '     * @return a / b\n', '     */\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Ownable {\n', '    address owner;\n', '    address newOwner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Allows execution by the owner only.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transferring the contract ownership to the new owner.\n', '     *\n', '     * @param _newOwner new contractor owner\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        if (_newOwner != 0x0) {\n', '          newOwner = _newOwner;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Accept the contract ownership by the new owner.\n', '     */\n', '    function acceptOwnership() {\n', '        require(msg.sender == newOwner);\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '        newOwner = 0x0;\n', '    }\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', '/**\n', '* Standard Token Smart Contract\n', '*/\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the numbers of tokens belonging\n', '     * to these token holders.\n', '     */\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of addresses of\n', '     * spenders to the allowances set by these token holders to these spenders.\n', '     */\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of token amount spent.\n', '     * Use by the token holders to spend their utility tokens.\n', '     */\n', '    mapping (address => mapping (address => uint256)) spentamount;\n', '\n', '    /**\n', '     * Mapping of the addition of patrons.\n', '     */\n', '    mapping (address => bool) patronAppended;\n', '\n', '    /**\n', '     * Mapping of the addresses of patrons.\n', '     */\n', '    address[] patrons;\n', '\n', '    /**\n', '     * Mapping of the addresses of VIP token holders.\n', '     */\n', '    address[] vips;\n', '\n', '    /**\n', '    * Mapping for VIP rank for qualified token holders\n', '    * Higher VIP rank (with earlier timestamp) has higher bidding priority when\n', '    * competing for the same product or service on platform.\n', '    */\n', '    mapping (address => uint256) viprank;\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to its owner\n', '     *\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(_to != 0x0);\n', '        if (balances[msg.sender] < _value) return false;\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) \n', '        returns (bool success) {\n', '        require(_to != 0x0);\n', '        if(_from == _to) return false;\n', '        if (balances[_from] < _value) return false;\n', '        if (_value > allowed[_from][msg.sender]) return false;\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling approve(_spender, 0) if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '           return false;\n', '        }\n', '        if (balances[msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '     }\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '     function allowance(address _owner, address _spender) constant \n', '        returns (uint256 remaining) {\n', '       return allowed[_owner][_spender];\n', '     }\n', '}\n', '\n', '/**\n', ' * LooksCoin Token\n', ' *\n', ' * LooksCoin Token is an utility token that can be purchased through crowdsale or earned on\n', ' * the LookRev platform. It can be spent to purchase creative products and services on\n', ' * LookRev platform.\n', ' *\n', ' * VIP rank is used to calculate priority when competing with other bids\n', ' * for the same product or service on the platform. \n', ' * Higher VIP rank (with earlier timestamp) has higher priority.\n', ' * Higher VIP rank wallet address owner can outbid other lower ranking owners only once\n', ' * per selling window or promotion period.\n', ' * VIP rank is recorded at the time when the wallet address first reach VIP LooksCoin \n', ' * holding level for a token purchaser.\n', ' * VIP rank is valid for the lifetime of a wallet address on the platform, as long as it \n', ' * meets the VIP holding level.\n', '\n', ' * Usage of the LooksCoin, VIP rank and token utilities are described on the website\n', ' * https://lookscoin.com.\n', ' *\n', ' */\n', 'contract LooksCoin is StandardToken, Ownable {\n', '\n', '    /**\n', '     * Number of decimals of the smallest unit\n', '     */\n', '    uint256 public constant decimals = 18;\n', '\n', '    /**\n', '     * VIP Holding Level. Minimium token holding amount to record a VIP rank.\n', '     * Token holding address needs have at least 24000 LooksCoin to be ranked as VIP\n', '     * VIP rank can only be set through purchasing tokens\n', '     */\n', '    uint256 public constant VIP_MINIMUM = 24000e18;\n', '\n', '    /**\n', '     * Initial number of tokens.\n', '     */\n', '    uint256 constant INITIAL_TOKENS_COUNT = 100000000e18;\n', '\n', '    /**\n', '     * Crowdsale contract address.\n', '     */\n', '    address public tokenSaleContract = 0x0;\n', '\n', '    /**\n', '     * Init Placeholder\n', '     */\n', '    address coinmaster = address(0xd3c79e4AD654436d59AfD61363Bc2B927d2fb680);\n', '\n', '    /**\n', '     * Create new LooksCoin token smart contract.\n', '     */\n', '    function LooksCoin() {\n', '        owner = coinmaster;\n', '        balances[owner] = INITIAL_TOKENS_COUNT;\n', '        totalSupply = INITIAL_TOKENS_COUNT;\n', '    }\n', '\n', '    /**\n', '     * Get name of this token.\n', '     *\n', '     * @return name of this token\n', '     */\n', '    function name() constant returns (string name) {\n', '      return "LooksCoin";\n', '    }\n', '\n', '    /**\n', '     * Get symbol of this token.\n', '     *\n', '     * @return symbol of this token\n', '     */\n', '    function symbol() constant returns (string symbol) {\n', '      return "LOOKS";\n', '    }\n', '\n', '    /**\n', '     * @dev Set new token sale contract.\n', '     * May only be called by owner.\n', '     *\n', '     * @param _newTokenSaleContract new token sale manage contract.\n', '     */\n', '    function setTokenSaleContract(address _newTokenSaleContract) {\n', '        require(msg.sender == owner);\n', '        assert(_newTokenSaleContract != 0x0);\n', '        tokenSaleContract = _newTokenSaleContract;\n', '    }\n', '\n', '    /**\n', '     * Get VIP rank of a given owner.\n', '     * VIP rank is valid for the lifetime of a token wallet address, \n', '     * as long as it meets VIP holding level.\n', '     *\n', '     * @param _to participant address to get the vip rank\n', '     * @return vip rank of the owner of given address\n', '     */\n', '    function getVIPRank(address _to) constant public returns (uint256 rank) {\n', '        if (balances[_to] < VIP_MINIMUM) {\n', '            return 0;\n', '        }\n', '        return viprank[_to];\n', '    }\n', '\n', '    /**\n', '     * Check and update VIP rank of a given token buyer.\n', '     * Contribution timestamp is recorded for VIP rank.\n', '     * Recorded timestamp for VIP rank should always be earlier than the current time.\n', '     *\n', '     * @param _to address to check the vip rank.\n', '     * @return rank vip rank of the owner of given address if any\n', '     */\n', '    function updateVIPRank(address _to) returns (uint256 rank) {\n', '        // Contribution timestamp is recorded for VIP rank\n', '        // Recorded timestamp for VIP rank should always be earlier than current time\n', '        if (balances[_to] >= VIP_MINIMUM && viprank[_to] == 0) {\n', '            viprank[_to] = now;\n', '            vips.push(_to);\n', '        }\n', '        return viprank[_to];\n', '    }\n', '\n', '    event TokenRewardsAdded(address indexed participant, uint256 balance);\n', '    /**\n', '     * Reward participant the tokens they purchased or earned\n', '     *\n', '     * @param _to address to credit tokens to the \n', '     * @param _value number of tokens to transfer to given recipient\n', '     *\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function rewardTokens(address _to, uint256 _value) {\n', '        require(msg.sender == tokenSaleContract || msg.sender == owner);\n', '        assert(_to != 0x0);\n', '        require(_value > 0);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        totalSupply = totalSupply.add(_value);\n', '        updateVIPRank(_to);\n', '        TokenRewardsAdded(_to, _value);\n', '    }\n', '\n', '    event SpentTokens(address indexed participant, address indexed recipient, uint256 amount);\n', '    /**\n', '     * Spend given number of tokens for a usage.\n', '     *\n', '     * @param _to address to spend utility tokens at\n', '     * @param _value number of tokens to spend\n', '     * @return true on success, false on error\n', '     */\n', '    function spend(address _to, uint256 _value) public returns (bool success) {\n', '        require(_value > 0);\n', '        assert(_to != 0x0);\n', '        if (balances[msg.sender] < _value) return false;\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        spentamount[msg.sender][_to] = spentamount[msg.sender][_to].add(_value);\n', '\n', '        SpentTokens(msg.sender, _to, _value);\n', '        if(!patronAppended[msg.sender]) {\n', '            patronAppended[msg.sender] = true;\n', '            patrons.push(msg.sender);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    /**\n', '     * Burn given number of tokens belonging to message sender.\n', '     * It can be applied by account with address this.tokensaleContract\n', '     *\n', '     * @param _value number of tokens to burn\n', '     * @return true on success, false on error\n', '     */\n', '    function burnTokens(address burner, uint256 _value) public returns (bool success) {\n', '        require(msg.sender == burner || msg.sender == owner);\n', '        assert(burner != 0x0);\n', '        if (_value > totalSupply) return false;\n', '        if (_value > balances[burner]) return false;\n', '        \n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Get the VIP owner at the index.\n', '     *\n', '     * @param index of the VIP owner on the VIP list\n', '     * @return address of the VIP owner\n', '     */\n', '    function getVIPOwner(uint256 index) constant returns (address vipowner) {\n', '        return (vips[index]);\n', '    }\n', '\n', '    /**\n', '     * Get the count of VIP owners.\n', '     *\n', '     * @return count of VIP owners list.\n', '     */\n', '    function getVIPCount() constant returns (uint256 count) {\n', '        return vips.length;\n', '    }\n', '\n', '    /**\n', '     * Get the patron at the index.\n', '     *\n', '     * @param index of the patron on the patron list\n', '     * @return address of the patron\n', '     */\n', '    function getPatron(uint256 index) constant returns (address patron) {\n', '        return (patrons[index]);\n', '    }\n', '\n', '    /**\n', '     * Get the count of patrons.\n', '     *\n', '     * @return number of patrons.\n', '     */\n', '    function getPatronsCount() constant returns (uint256 count) {\n', '        return patrons.length;\n', '    }\n', '}']