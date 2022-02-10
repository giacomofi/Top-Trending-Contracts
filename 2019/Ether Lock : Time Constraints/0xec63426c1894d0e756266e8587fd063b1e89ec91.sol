['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-08\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BasicERC20\n', '{\n', '    /* Public variables of the token */\n', '    string public standard = &#39;ERC20&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    bool public isTokenTransferable = true;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        assert(isTokenTransferable);\n', '        assert(balanceOf[msg.sender] >= _value);             // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public\n', '    returns (bool success)  {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        assert(isTokenTransferable || _from == address(0x0)); // allow to transfer for crowdsale\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract BasicCrowdsale is Ownable\n', '{\n', '    using SafeMath for uint256;\n', '    BasicERC20 token;\n', '\n', '    address public ownerWallet;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    uint256 public totalEtherRaised = 0;\n', '    uint256 public totalTokensSold = 0;\n', '\n', '    uint256 public softCapEther;\n', '    uint256 public hardCapEther;\n', '\n', '    mapping(address => uint256) private deposits;\n', '    mapping(address => uint256) public amounts;\n', '\n', '    constructor () public {\n', '\n', '    }\n', '\n', '    function () external payable {\n', '        buy(msg.sender);\n', '    }\n', '\n', '    function getSettings () view public returns(uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _rate,\n', '        uint256 _totalEtherRaised,\n', '        uint256 _maxAmount,\n', '        uint256 _tokensLeft ) {\n', '\n', '        _startTime = startTime;\n', '        _endTime = endTime;\n', '        _rate = getRate();\n', '        _totalEtherRaised = totalEtherRaised;\n', '        _maxAmount = getMaxAmount();\n', '        _tokensLeft = tokensLeft();\n', '    }\n', '\n', '    function tokensLeft() view public returns (uint256)\n', '    {\n', '        return token.balanceOf(address(0x0));\n', '    }\n', '\n', '    function getRate() view public returns (uint256) {\n', '        assert(false);\n', '    }\n', '\n', '    function getMinAmount(address userAddress) view public returns (uint256) {\n', '        assert(false);\n', '    }\n', '\n', '    function getMaxAmount() view public returns (uint256) {\n', '        assert(false);\n', '    }\n', '\n', '    function getTokenAmount(uint256 weiAmount) public view returns(uint256) {\n', '        return weiAmount.mul(getRate());\n', '    }\n', '\n', '    function checkCorrectPurchase() view internal {\n', '        require(startTime < now && now < endTime);\n', '        require(totalEtherRaised + msg.value < hardCapEther);\n', '    }\n', '\n', '    function isCrowdsaleFinished() view public returns(bool)\n', '    {\n', '        return totalEtherRaised >= hardCapEther || now > endTime;\n', '    }\n', '\n', '    function buy(address userAddress) public payable {\n', '        require(userAddress != address(0));\n', '        checkCorrectPurchase();\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = getTokenAmount(msg.value);\n', '\n', '        assert(tokens >= getMinAmount(userAddress));\n', '        assert(tokens.add(totalTokensSold) <= getMaxAmount());\n', '\n', '        // update state\n', '        totalEtherRaised = totalEtherRaised.add(msg.value);\n', '        totalTokensSold = totalTokensSold.add(tokens);\n', '\n', '        token.transferFrom(address(0x0), userAddress, tokens);\n', '        amounts[userAddress] = amounts[userAddress].add(tokens);\n', '\n', '        if (totalEtherRaised >= softCapEther)\n', '        {\n', '            ownerWallet.transfer(this.balance);\n', '        }\n', '        else\n', '        {\n', '            deposits[userAddress] = deposits[userAddress].add(msg.value);\n', '        }\n', '    }\n', '\n', '    function getRefundAmount(address userAddress) view public returns (uint256)\n', '    {\n', '        if (totalEtherRaised >= softCapEther) return 0;\n', '        return deposits[userAddress];\n', '    }\n', '\n', '    function refund(address userAddress) public\n', '    {\n', '        assert(totalEtherRaised < softCapEther && now > endTime);\n', '        uint256 amount = deposits[userAddress];\n', '        deposits[userAddress] = 0;\n', '        amounts[userAddress] = 0;\n', '        userAddress.transfer(amount);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Crowdsale is BasicCrowdsale\n', '{\n', '    constructor () public {\n', '        ownerWallet = 0xb02ea41cf7e8c47d5958defda88e46b9786e12ae;\n', '        startTime = 1564617600;\n', '        endTime = 1609459199;\n', '        token = BasicERC20(0x2a629aac0a49c7f51f23a6ff92deecf27b554aa0);\n', '        softCapEther = 1000000000000000000;\n', '        hardCapEther = 125000000000000000000000000;\n', '\n', '        transferOwnership(0xb02ea41cf7e8c47d5958defda88e46b9786e12ae);\n', '    }\n', '\n', '    function getRate() view public returns (uint256) {\n', '        // you can convert unix timestamp to human date here https://www.epochconverter.com\n', '        // 2019-08-01T00:00:00\n', '        if (block.timestamp <= 1567296000) return 9;\n', '        // 2019-10-30T00:00:00\n', '        if (block.timestamp <= 1575158400) return 7;\n', '        return 5;\n', '\n', '    }\n', '\n', '    function getMinAmount(address userAddress) view public returns (uint256) {\n', '        // you can convert unix timestamp to human date here https://www.epochconverter.com\n', '        // 2019-08-01T00:00:00\n', '        if (block.timestamp <= 1567296000){\n', '            if(amounts[userAddress] < 10000000000000000000000){\n', '                return uint256(10000000000000000000000).sub(amounts[userAddress]);\n', '            }\n', '            else{\n', '                return 1000000000000000000;\n', '            }\n', '        }\n', '        // 2019-10-30T00:00:00\n', '        if (block.timestamp <= 1575158400){\n', '            if(amounts[userAddress] < 10000000000000000000000){\n', '                return uint256(10000000000000000000000).sub(amounts[userAddress]);\n', '            }\n', '            else{\n', '                return 1000000000000000000;\n', '            }\n', '        }\n', '        return 1;\n', '    }\n', '\n', '    function getMaxAmount() view public returns (uint256) {\n', '        // you can convert unix timestamp to human date here https://www.epochconverter.com\n', '        // 2019-08-01T00:00:00\n', '        if (block.timestamp <= 1567296000) return 100000000000000000000000000;\n', '        // 2019-10-30T00:00:00\n', '        if (block.timestamp <= 1575158400) return 100000000000000000000000000;\n', '        return 750000000000000000000000000;\n', '    }\n', '}']