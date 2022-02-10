['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '    \n', '    function unpause() onlyOwner whenPaused {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns(bool success) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns(bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) returns(bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        \n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner public returns(bool success) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract RewardToken is StandardToken, Ownable {\n', '    struct Payment {\n', '        uint time;\n', '        uint amount;\n', '        uint total;\n', '    }\n', '\n', '    Payment[] public repayments;\n', '    mapping(address => Payment[]) public rewards;\n', '\n', '    event Repayment(uint256 amount);\n', '    event Reward(address indexed to, uint256 amount);\n', '\n', '    function repayment(uint amount) onlyOwner {\n', '        require(amount >= 1000);\n', '\n', '        repayments.push(Payment({time : now, amount : amount * 1 ether, total : totalSupply}));\n', '\n', '        Repayment(amount * 1 ether);\n', '    }\n', '\n', '    function _reward(address _to) private returns(bool) {\n', '        if(rewards[_to].length < repayments.length) {\n', '            uint sum = 0;\n', '            for(uint i = rewards[_to].length; i < repayments.length; i++) {\n', '                uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / repayments[i].total) : 0;\n', '                rewards[_to].push(Payment({time : now, amount : amount, total : repayments[i].total}));\n', '                sum += amount;\n', '            }\n', '\n', '            if(sum > 0) {\n', '                totalSupply = totalSupply.add(sum);\n', '                balances[_to] = balances[_to].add(sum);\n', '                \n', '                Reward(_to, sum);\n', '            }\n', '\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function reward() returns(bool) {\n', '        return _reward(msg.sender);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns(bool) {\n', '        _reward(msg.sender);\n', '        _reward(_to);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool) {\n', '        _reward(_from);\n', '        _reward(_to);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', '/*\n', '    ICO Mining Data Center Coin\n', '    - Эмиссия токенов не ограниченна (токены можно сжигать)\n', '    - Цена токена на PreICO фиксированная: 1 ETH = 634 токенов\n', '    - Цена токена на ICO фиксированная: 1 ETH = 317 токенов\n', '    - Минимальная и максимальная сумма покупки: 0.001 ETH и 100 ETH\n', '    - Цена эфира фиксированная 1 ETH = 300 USD\n', '    - Верхная сумма сборов 22 000 000 USD (свыше токены не продаются, сдача не дается, предел можно преодолеть)\n', '    - Средства от покупки токенов сразу передаются бенефициару\n', '    - Crowdsale ограничен по времени\n', '    - Закрытие Crowdsale происходит с помощью функции `withdraw()`: управление токеном передаются бенефициару, выпуск токенов завершается\n', '    - На Token могут быть начислены дивиденды в виде токенов функцией `repayment(amount)` где amount - кол-во токенов\n', '    - Чтобы забрать дивиденды держателю токенов необходимо вызвать у Token функцию `reward()`\n', '*/\n', 'contract Token is RewardToken, MintableToken, BurnableToken {\n', '    string public name = "Mining Data Center Coin";\n', '    string public symbol = "MDCC";\n', '    uint256 public decimals = 18;\n', '\n', '    function Token() {\n', '    }\n', '}\n', '\n', 'contract Crowdsale is Pausable {\n', '    using SafeMath for uint;\n', '\n', '    Token public token;\n', '    address public beneficiary = 0x7cE9A678A78Dca8555269bA39036098aeA68b819;        // Beneficiary\n', '\n', '    uint public collectedWei;\n', '    uint public tokensSold;\n', '\n', '    uint public piStartTime = 1512162000;                                           // Date start   Sat Dec 02 2017 00:00:00 GMT+0300 (Калининградское время (зима))\n', '    uint public piEndTime = 1514753999;                                             // Date end     Sun Dec 31 2017 23:59:59 GMT+0300 (Калининградское время (зима))\n', '    uint public startTime = 1516006800;                                             // Date start   Mon Jan 15 2018 12:00:00 GMT+0300 (Калининградское время (зима))\n', '    uint public endTime = 1518685200;                                               // Date end     Thu Feb 15 2018 12:00:00 GMT+0300 (Калининградское время (зима))\n', '    bool public crowdsaleFinished = false;\n', '\n', '    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '    event Withdraw();\n', '\n', '    function Crowdsale() {\n', '        token = new Token();\n', '    }\n', '\n', '    function() payable {\n', '        purchase();\n', '    }\n', '    \n', '    function purchase() whenNotPaused payable {\n', '        require(!crowdsaleFinished);\n', '        require((now >= piStartTime && now < piEndTime) || (now >= startTime && now < endTime));\n', '        require(msg.value >= 0.001 * 1 ether && msg.value <= 100 * 1 ether);\n', '        require(collectedWei.mul(350) < 22000000 * 1 ether);\n', '\n', '        uint sum = msg.value;\n', '        uint amount = sum.mul(now < piEndTime ? 634 : 317);\n', '\n', '        tokensSold = tokensSold.add(amount);\n', '        collectedWei = collectedWei.add(sum);\n', '\n', '        token.mint(msg.sender, amount);\n', '        beneficiary.transfer(sum);\n', '\n', '        NewContribution(msg.sender, amount, sum);\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        require(!crowdsaleFinished);\n', '\n', '        token.finishMinting();\n', '        token.transferOwnership(beneficiary);\n', '\n', '        crowdsaleFinished = true;\n', '\n', '        Withdraw();\n', '    }\n', '}']