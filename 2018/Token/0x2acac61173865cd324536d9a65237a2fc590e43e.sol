['pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function StandardToken(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        require(_to.length == _value.length);\n', '\n', '        for(uint i = 0; i < _to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '    modifier notMint() { require(mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CappedToken is MintableToken {\n', '    uint256 public cap;\n', '\n', '    function CappedToken(uint256 _cap) public {\n', '        require(_cap > 0);\n', '        cap = _cap;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        require(totalSupply.add(_amount) <= cap);\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '/*\n', '\n', 'ICO Gap\n', '\n', '    - Crowdsale goes in 4 steps:\n', '    - 1st step PreSale 0: the administrator can issue tokens; purchase and sale are closed; Max. tokens 5 000 000\n', '    - 2nd step PreSale 1: the administrator can not issue tokens; the sale is open; purchase is closed; Max. tokens 5 000 000 + 10 000 000\n', '    - The third step of PreSale 2: the administrator can not issue tokens; the sale is open; purchase is closed; Max. tokens 5 000 000 + 10 000 000 + 15 000 000\n', '    - 4th step ICO: administrator can not issue tokens; the sale is open; the purchase is open; Max. tokens 5 000 000 + 10 000 000 + 15 000 000 + 30 000 000\n', '\n', '    Addition:\n', '    - Total emissions are limited: 100,000,000 tokens\n', '    - at each step it is possible to change the price of the token\n', '    - the steps are not limited in time and the step change is made by the nextStep administrator\n', '    - funds are accumulated on a contract basis\n', '    - at any time closeCrowdsale can be called: the funds and management of the token are transferred to the beneficiary; the release of + 65% of tokens to the beneficiary; minting closes\n', '    - at any time, refundCrowdsale can be called: funds remain on the contract; withdraw becomes unavailable; there is an opportunity to get refund \n', '    - transfer of tokens before closeCrowdsale is unavailable\n', '    - you can buy no more than 500 000 tokens for 1 purse.\n', '*/\n', '\n', 'contract Token is CappedToken, BurnableToken {\n', '    function Token() CappedToken(100000000 * 1 ether) StandardToken("GAP Token", "GAP", 18) public {\n', '        \n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) notMint public returns(bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) notMint public returns(bool) {\n', '        return super.multiTransfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) notMint public returns(bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function burnOwner(address _from, uint256 _value) onlyOwner canMint public {\n', '        require(_value <= balances[_from]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(_from, _value);\n', '    }\n', '}\n', '\n', 'contract Crowdsale is Pausable {\n', '    using SafeMath for uint;\n', '\n', '    struct Step {\n', '        uint priceTokenWei;\n', '        uint tokensForSale;\n', '        uint tokensSold;\n', '        uint collectedWei;\n', '\n', '        bool purchase;\n', '        bool issue;\n', '        bool sale;\n', '    }\n', '\n', '    Token public token;\n', '    address public beneficiary = 0x4B97b2938844A775538eF0b75F08648C4BD6fFFA;\n', '\n', '    Step[] public steps;\n', '    uint8 public currentStep = 0;\n', '\n', '    bool public crowdsaleClosed = false;\n', '    bool public crowdsaleRefund = false;\n', '    uint public refundedWei;\n', '\n', '    mapping(address => uint256) public canSell;\n', '    mapping(address => uint256) public purchaseBalances; \n', '\n', '    event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '    event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '    event Issue(address indexed holder, uint256 tokenAmount);\n', '    event Refund(address indexed holder, uint256 etherAmount);\n', '    event NextStep(uint8 step);\n', '    event CrowdsaleClose();\n', '    event CrowdsaleRefund();\n', '\n', '    function Crowdsale() public {\n', '        token = new Token();\n', '\n', '        steps.push(Step(1 ether / 1000, 5000000 * 1 ether, 0, 0, false, true, false));\n', '        steps.push(Step(1 ether / 1000, 10000000 * 1 ether, 0, 0, true, false, false));\n', '        steps.push(Step(1 ether / 500, 15000000 * 1 ether, 0, 0, true, false, false));\n', '        steps.push(Step(1 ether / 100, 30000000 * 1 ether, 0, 0, true, false, true));\n', '    }\n', '\n', '    function() payable public {\n', '        purchase();\n', '    }\n', '\n', '    function setTokenRate(uint _value) onlyOwner whenPaused public {\n', '        require(!crowdsaleClosed);\n', '        steps[currentStep].priceTokenWei = 1 ether / _value;\n', '    }\n', '    \n', '    function purchase() whenNotPaused payable public {\n', '        require(!crowdsaleClosed);\n', '        require(msg.value >= 0.001 ether);\n', '\n', '        Step memory step = steps[currentStep];\n', '\n', '        require(step.purchase);\n', '        require(step.tokensSold < step.tokensForSale);\n', '        require(token.balanceOf(msg.sender) < 500000 ether);\n', '\n', '        uint sum = msg.value;\n', '        uint amount = sum.mul(1 ether).div(step.priceTokenWei);\n', '        uint retSum = 0;\n', '        uint retAmount;\n', '        \n', '        if(step.tokensSold.add(amount) > step.tokensForSale) {\n', '            retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);\n', '            retSum = retAmount.mul(step.priceTokenWei).div(1 ether);\n', '\n', '            amount = amount.sub(retAmount);\n', '            sum = sum.sub(retSum);\n', '        }\n', '\n', '        if(token.balanceOf(msg.sender).add(amount) > 500000 ether) {\n', '            retAmount = token.balanceOf(msg.sender).add(amount).sub(500000 ether);\n', '            retSum = retAmount.mul(step.priceTokenWei).div(1 ether);\n', '\n', '            amount = amount.sub(retAmount);\n', '            sum = sum.sub(retSum);\n', '        }\n', '\n', '        steps[currentStep].tokensSold = step.tokensSold.add(amount);\n', '        steps[currentStep].collectedWei = step.collectedWei.add(sum);\n', '        purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);\n', '\n', '        token.mint(msg.sender, amount);\n', '\n', '        if(retSum > 0) {\n', '            msg.sender.transfer(retSum);\n', '        }\n', '\n', '        Purchase(msg.sender, amount, sum);\n', '    }\n', '\n', '    function issue(address _to, uint256 _value) onlyOwner whenNotPaused public {\n', '        require(!crowdsaleClosed);\n', '\n', '        Step memory step = steps[currentStep];\n', '        \n', '        require(step.issue);\n', '        require(step.tokensSold.add(_value) <= step.tokensForSale);\n', '\n', '        steps[currentStep].tokensSold = step.tokensSold.add(_value);\n', '        canSell[_to] = canSell[_to].add(_value).div(100).mul(20);\n', '\n', '        token.mint(_to, _value);\n', '\n', '        Issue(_to, _value);\n', '    }\n', '\n', '    function sell(uint256 _value) whenNotPaused public {\n', '        require(!crowdsaleClosed);\n', '\n', '        require(canSell[msg.sender] >= _value);\n', '        require(token.balanceOf(msg.sender) >= _value);\n', '\n', '        Step memory step = steps[currentStep];\n', '        \n', '        require(step.sale);\n', '\n', '        canSell[msg.sender] = canSell[msg.sender].sub(_value);\n', '        token.burnOwner(msg.sender, _value);\n', '\n', '        uint sum = _value.mul(step.priceTokenWei).div(1 ether);\n', '\n', '        msg.sender.transfer(sum);\n', '\n', '        Sell(msg.sender, _value, sum);\n', '    }\n', '    \n', '    function refund() public {\n', '        require(crowdsaleRefund);\n', '        require(purchaseBalances[msg.sender] > 0);\n', '\n', '        uint sum = purchaseBalances[msg.sender];\n', '\n', '        purchaseBalances[msg.sender] = 0;\n', '        refundedWei = refundedWei.add(sum);\n', '\n', '        msg.sender.transfer(sum);\n', '        \n', '        Refund(msg.sender, sum);\n', '    }\n', '\n', '    function nextStep() onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '        require(steps.length - 1 > currentStep);\n', '        \n', '        currentStep += 1;\n', '\n', '        NextStep(currentStep);\n', '    }\n', '\n', '    function closeCrowdsale() onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '        \n', '        beneficiary.transfer(this.balance);\n', '        token.mint(beneficiary, token.totalSupply().div(100).mul(65));\n', '        token.finishMinting();\n', '        token.transferOwnership(beneficiary);\n', '\n', '        crowdsaleClosed = true;\n', '\n', '        CrowdsaleClose();\n', '    }\n', '\n', '    function refundCrowdsale() onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '\n', '        crowdsaleRefund = true;\n', '        crowdsaleClosed = true;\n', '\n', '        CrowdsaleRefund();\n', '    }\n', '}']