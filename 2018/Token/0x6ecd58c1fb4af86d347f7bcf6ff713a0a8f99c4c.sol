['pragma solidity ^0.4.21;\n', '\n', '// SafeMath is a part of Zeppelin Solidity library\n', '// licensed under MIT License\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// https://github.com/OpenZeppelin/zeppelin-solidity\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Protection from short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        _postTransferHook(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Hook for custom actions to be executed after transfer has completed\n', '    * @param _from Transferred from\n', '    * @param _to Transferred to\n', '    * @param _value Value transferred\n', '    */\n', '    function _postTransferHook(address _from, address _to, uint256 _value) internal;\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        _postTransferHook(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract Owned {\n', '    address owner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /// @dev Contract constructor\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'contract AcceptsTokens {\n', '    ETToken public tokenContract;\n', '\n', '    function AcceptsTokens(address _tokenContract) public {\n', '        tokenContract = ETToken(_tokenContract);\n', '    }\n', '\n', '    modifier onlyTokenContract {\n', '        require(msg.sender == address(tokenContract));\n', '        _;\n', '    }\n', '\n', '    function acceptTokens(address _from, uint256 _value, uint256 param1, uint256 param2, uint256 param3) external;\n', '}\n', '\n', 'contract ETToken is Owned, StandardToken {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "ETH.TOWN Token";\n', '    string public symbol = "ETIT";\n', '    uint8 public decimals = 18;\n', '\n', '    address public beneficiary;\n', '    address public oracle;\n', '    address public heroContract;\n', '    modifier onlyOracle {\n', '        require(msg.sender == oracle);\n', '        _;\n', '    }\n', '\n', '    mapping (uint32 => address) public floorContracts;\n', '    mapping (address => bool) public canAcceptTokens;\n', '\n', '    mapping (address => bool) public isMinter;\n', '\n', '    modifier onlyMinters {\n', '        require(msg.sender == owner || isMinter[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    event Dividend(uint256 value);\n', '    event Withdrawal(address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function ETToken() public {\n', '        oracle = owner;\n', '        beneficiary = owner;\n', '\n', '        totalSupply_ = 0;\n', '    }\n', '\n', '    function setOracle(address _oracle) external onlyOwner {\n', '        oracle = _oracle;\n', '    }\n', '    function setBeneficiary(address _beneficiary) external onlyOwner {\n', '        beneficiary = _beneficiary;\n', '    }\n', '    function setHeroContract(address _heroContract) external onlyOwner {\n', '        heroContract = _heroContract;\n', '    }\n', '\n', '    function _mintTokens(address _user, uint256 _amount) private {\n', '        require(_user != 0x0);\n', '\n', '        balances[_user] = balances[_user].add(_amount);\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '\n', '        emit Transfer(address(this), _user, _amount);\n', '    }\n', '\n', '    function authorizeFloor(uint32 _index, address _floorContract) external onlyOwner {\n', '        floorContracts[_index] = _floorContract;\n', '    }\n', '\n', '    function _acceptDividends(uint256 _value) internal {\n', '        uint256 beneficiaryShare = _value / 5;\n', '        uint256 poolShare = _value.sub(beneficiaryShare);\n', '\n', '        beneficiary.transfer(beneficiaryShare);\n', '\n', '        emit Dividend(poolShare);\n', '    }\n', '\n', '    function acceptDividends(uint256 _value, uint32 _floorIndex) external {\n', '        require(floorContracts[_floorIndex] == msg.sender);\n', '\n', '        _acceptDividends(_value);\n', '    }\n', '\n', '    function rewardTokensFloor(address _user, uint256 _tokens, uint32 _floorIndex) external {\n', '        require(floorContracts[_floorIndex] == msg.sender);\n', '\n', '        _mintTokens(_user, _tokens);\n', '    }\n', '\n', '    function rewardTokens(address _user, uint256 _tokens) external onlyMinters {\n', '        _mintTokens(_user, _tokens);\n', '    }\n', '\n', '    function() payable public {\n', '        // Intentionally left empty, for use by floors\n', '    }\n', '\n', '    function payoutDividends(address _user, uint256 _value) external onlyOracle {\n', '        _user.transfer(_value);\n', '\n', '        emit Withdrawal(_user, _value);\n', '    }\n', '\n', '    function accountAuth(uint256 /*_challenge*/) external {\n', '        // Does nothing by design\n', '    }\n', '\n', '    function burn(uint256 _amount) external {\n', '        require(balances[msg.sender] >= _amount);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        totalSupply_ = totalSupply_.sub(_amount);\n', '\n', '        emit Burn(msg.sender, _amount);\n', '    }\n', '\n', '    function setCanAcceptTokens(address _address, bool _value) external onlyOwner {\n', '        canAcceptTokens[_address] = _value;\n', '    }\n', '\n', '    function setIsMinter(address _address, bool _value) external onlyOwner {\n', '        isMinter[_address] = _value;\n', '    }\n', '\n', '    function _invokeTokenRecipient(address _from, address _to, uint256 _value, uint256 _param1, uint256 _param2, uint256 _param3) internal {\n', '        if (!canAcceptTokens[_to]) {\n', '            return;\n', '        }\n', '\n', '        AcceptsTokens recipient = AcceptsTokens(_to);\n', '\n', '        recipient.acceptTokens(_from, _value, _param1, _param2, _param3);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address and forward the parameters to token recipient if any\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @param _param1 Parameter 1 for the token recipient\n', '    * @param _param2 Parameter 2 for the token recipient\n', '    * @param _param3 Parameter 3 for the token recipient\n', '    */\n', '    function transferWithParams(address _to, uint256 _value, uint256 _param1, uint256 _param2, uint256 _param3) onlyPayloadSize(5 * 32) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        _invokeTokenRecipient(msg.sender, _to, _value, _param1, _param2, _param3);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Hook for custom actions to be executed after transfer has completed\n', '    * @param _from Transferred from\n', '    * @param _to Transferred to\n', '    * @param _value Value transferred\n', '    */\n', '    function _postTransferHook(address _from, address _to, uint256 _value) internal {\n', '        _invokeTokenRecipient(_from, _to, _value, 0, 0, 0);\n', '    }\n', '\n', '\n', '}\n', '\n', 'contract PresaleContract is Owned {\n', '    ETToken public tokenContract;\n', '\n', '    /// @dev Contract constructor\n', '    function PresaleContract(address _tokenContract) public {\n', '        tokenContract = ETToken(_tokenContract);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ETStarPresale is PresaleContract {\n', '    using SafeMath for uint;\n', '\n', '    uint256 public auctionEnd;\n', '    uint256 public itemType;\n', '\n', '    address public highestBidder;\n', '    uint256 public highestBid;\n', '    bool public ended;\n', '\n', '    event Bid(address from, uint256 amount);\n', '    event AuctionEnded(address winner, uint256 amount);\n', '\n', '    function ETStarPresale(address _presaleToken, uint256 _auctionEnd, uint256 _itemType)\n', '        PresaleContract(_presaleToken)\n', '        public\n', '    {\n', '        auctionEnd = _auctionEnd;\n', '        itemType = _itemType;\n', '    }\n', '\n', '    function _isContract(address _user) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(_user) }\n', '        return size > 0;\n', '    }\n', '\n', '    function auctionExpired() public view returns (bool) {\n', '        return now > auctionEnd;\n', '    }\n', '\n', '    function() public payable {\n', '        require(!_isContract(msg.sender));\n', '        require(!auctionExpired());\n', '\n', '        require(msg.value > highestBid);\n', '\n', '        if (highestBid != 0) {\n', '            highestBidder.transfer(highestBid);\n', '        }\n', '\n', '        highestBidder = msg.sender;\n', '        highestBid = msg.value;\n', '\n', '        emit Bid(msg.sender, msg.value);\n', '    }\n', '\n', '    function endAuction() public onlyOwner {\n', '        require(auctionExpired());\n', '        require(!ended);\n', '\n', '        ended = true;\n', '        emit AuctionEnded(highestBidder, highestBid);\n', '        tokenContract.rewardTokens(highestBidder, highestBid * 200);\n', '\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']