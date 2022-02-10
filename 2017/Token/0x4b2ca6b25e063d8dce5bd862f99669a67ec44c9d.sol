['pragma solidity 0.4.19;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() constant public returns (uint256 total);\n', '\n', '    function balanceOf(address _who) constant public returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract BitandPay is ERC20Interface {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "BitandPay";\n', '    string public symbol = "BNP";\n', '    uint256 public totalSupply = 250000000;\n', '\n', '    uint8 public decimals = 0; // from 0 to 18\n', '\n', '    address public owner;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public startTime = 1513296000; // 15 dec 2017 00.00.00\n', '    uint256 public endTime = 1518739199; // 15 feb 2018 23.59.59 UNIX timestamp\n', '    // 31 march 2018 23.59.59 - 1522540799\n', '\n', '    uint256 public price = 1428571428571400 wei; // price in wei, 1 bnp = 0,0014285714285714, 1 eth = 700 bnp\n', '\n', '    uint256 public weiRaised;\n', '\n', '    bool public paused = false;\n', '\n', '    uint256 reclaimAmount;\n', '\n', '    /**\n', '     * @notice Cap is a max amount of funds raised in wei. 1 Ether = 10**18 wei.\n', '     */\n', '    uint256 public cap = 1000000 ether;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function BitandPay() public {\n', '        owner = msg.sender;\n', '        balances[owner] = 250000000;\n', '        Transfer(0x0, owner, 250000000);\n', '    }\n', '\n', '    function totalSupply() constant public returns (uint256 total) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _who) constant public  returns (uint256 balance) {\n', '        return balances[_who];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) whenNotPaused public\n', '    returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) whenNotPaused public\n', '    returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner public returns (bool success) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(0x0, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '    function () payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address purchaser) payable whenNotPaused public {\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(price);\n', '        require(balances[this] > tokens);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', "        balances[purchaser] = balances[purchaser].add(tokens);  // adds the amount to buyer's balance\n", "        balances[this] = balances[this].sub(tokens);            // subtracts amount from seller's balance\n", '        Transfer(this, purchaser, tokens);                      // execute an event reflecting the change\n', '        TokenPurchase(purchaser, weiAmount, tokens);\n', '    }\n', '\n', '    function validPurchase() internal constant returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        bool withinCap = weiRaised.add(msg.value) <= cap;\n', '        return withinPeriod && nonZeroPurchase && withinCap;\n', '    }\n', '\n', '    function hasEnded() public constant returns (bool) {\n', '        bool capReached = weiRaised >= cap;\n', '        return now > endTime || capReached;\n', '    }\n', '\n', '    function changeCap(uint256 _cap) onlyOwner public {\n', '        require(_cap > 0);\n', '        cap = _cap;\n', '    }\n', '\n', '    event Price(uint256 value);\n', '\n', '    function changePrice(uint256 _price) onlyOwner public {\n', '        price = _price;\n', '        Price(price);\n', '    }\n', '\n', '    event Pause();\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    event Unpause();\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '\n', '    function destroy() onlyOwner public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function destroyAndSend(address _recipient) onlyOwner public {\n', '        selfdestruct(_recipient);\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '       \towner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '    }\n', '\n', '    function reclaimToken(ERC20Interface token) external onlyOwner {\n', '        reclaimAmount = token.balanceOf(this);\n', '        token.transfer(owner, reclaimAmount);\n', '        reclaimAmount = 0;\n', '    }\n', '\n', '    function withdrawToOwner(uint256 _amount) onlyOwner public {\n', '        require(this.balance >= _amount);\n', '        owner.transfer(_amount);\n', '    }\n', '\n', '    function withdrawToAdress(address _to, uint256 _amount) onlyOwner public {\n', '        require(_to != address(0));\n', '        require(this.balance >= _amount);\n', '        _to.transfer(_amount);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']