['/*! gbcoin.sol | (c) 2017 Develop by BelovITLab, autor my.life.cookie | License: MIT */\n', '\n', '/*\n', '\n', '    Russian\n', '\n', '    Что такое GB Systems:\n', '    Это Geo Blockchain система, которая не привязывается ни к одной стране и банкам. У нас есть свой \n', '    процессинговый центр, эквайринг и платежная система GBPay - аналог Visa, MasterCard, UnionPay. \n', '    Все транзакции которые будут проходить внутри системы и банков партнеров моментально. Так же, \n', '    подключающиеся компании партнеров и банки, имеют возможность использовать всю систему для своего \n', '    бизнеса, путем интеграции API кода и использовать все возможности нашей системы для своих клиентов. \n', '    Каждому партнеру выгодно сотрудничать с нашей системой, что позволить увеличить количество клиентов \n', '    во всем мире. В нашей системе скоро будет холодный кошелек GB Wallet, где можно хранить криптовалюту \n', '    и национальную валюту любой страны. Компания GB Network позволит каждому клиенту приобрести виртуальный \n', '    счет, где можно хранить средства, и совершать покупку путем приложения NFC, одним касанием к Пост \n', '    Терминалу, а также покупать и оплачивать услуги и товары через онлайн систему. Так же компания дает \n', '    возможность зарабатывать на партнерской программе. Мы не забыли и о благотворительном фонде, который \n', '    будет межуднародный и не привязываться к одной стране. Часть средств от нашей системы будет поступать \n', '    в этот фонд.\n', '    \n', '    Банкам партнерам разрешается по мимо нашей системы, имитировать пластиковые карты для своих и наших \n', '    клиентов  всей системы, в национальной валюте, с применением нашей платежной системой с нашим логотипом \n', '    GBPay, и с использованием  нашей платформы Blockchain, куда входит эквайринг, процессинговый центр и \n', '    платежная система, все это за 1,2%. Границ между странами в нашей системе нет, что позволяет совершать \n', '    платежи и переводы за секунду в любою точку земного шара. Для работы в системе, мы создали токен GBCoin, \n', '    который будет отвечать за весь функционал финансовой системы GB Systems, как внутренняя международная \n', '    транзакционная валюта системы, которой будут привязаны все наши компании и банки. \n', '    \n', '    К нашей системе GB Systems подключены: Grande Bank, Grande Finance, GB Network, GBMarkets, GB Wallet, \n', '    Charity Foundation, GBPay.\n', '    \n', '    Мы так же будем предоставлять потребительские кредиты, автокредитование, ипотечное кредитование, \n', '    под минимальные проценты, открываеть депозитные и инвестиционные вклады, вклады на доверительное \n', '    управление, страхование с большими возможностями, обменник валют, платежная система, так же можно \n', '    будет  оплачивать нашей криптовалютой GBCoin услуги такси в разных странах, оплачивать за \n', '    туристические путевки у туроператоров,  По системе лояльности иметь возможность получать скидки \n', '    и cash back в продуктовых магазинах партнеров и многое другое. \n', '    \n', '    С нами вы будете иметь все в одной системе и не нужно будет обращаться в сторонние структуры. \n', '    Удобство и Качество для всех клиентов.\n', '\n', '\n', '\n', '    English\n', '\n', '    What is GB Systems:\n', '    It is Geo Blockchain system which does not become attached to one country and banks. \n', '    We have the processing center, acquiring and GBPay payment provider - this analog  Visa, MasterCard, \n', '    UnionPay. All transactions which will take place in system and banks of partners instantly. Also, \n', '    the connected partner companies and banks, have an opportunity to use all system for the business, \n', '    by integration of an API code and to use all opportunities of our system for the clients. It is \n', '    profitable to each partner to cooperate with our system what to allow to increase the number of \n', '    clients around the world. In our system there will be soon a cold purse of GB Wallet where it is \n', '    possible to keep cryptocurrency and national currency of any country. The GB Network company will \n', '    allow each client to purchase the virtual account where it is possible to store means and to make \n', '    purchase by the application NFC, one contact to the Post to the Terminal and also to buy and pay \n', '    services and goods through online system. Also the company gives the chance to earn on the partner \n', '    program. We did not forget also about charity foundation which will be mezhudnarodny and not to \n', '    become attached to one country. A part of means from our system will come to this fund. To partners \n', '    it is allowed to banks on by our system, to imitate plastic cards for the and our clients of all \n', '    system, in national currency, using our payment service provider with our GBPay logo, and with use \n', '    of our Blockchain platform where acquiring, a processing center and a payment service provider, \n', '    all this for 1,2% enters. There are no borders between the countries in our system that allows \n', '    to make payments and transfers for second in any a globe point. For work in system, we created \n', '    a token of GBCoin which will be responsible for all functionality of the GB Systems financial \n', '    system as internal world transactional currency of system which will attach all our companies \n', '    and banks.\n', '\n', '    Our system is already connected Grande Bank, Grande Finance, GB Network, GBMarkets, GB Wallet, \n', '    Charity Foundation, GBPay.\n', '\n', '*/\n', '\n', 'pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '    \n', '    function unpause() onlyOwner whenPaused {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns(bool success) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns(bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) returns(bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        \n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '\n', '        address burner = msg.sender;\n', '\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '    uint public MAX_SUPPLY;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {\n', '        require(totalSupply.add(_amount) <= MAX_SUPPLY);\n', '\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner public returns(bool success) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/*\n', '    ICO GBCoin\n', '    - Эмиссия токенов ограничена (всего 40 000 000 токенов, токены выпускаются во время Crowdsale)\n', '    - Цена токена во время старта: 1 ETH = 20 токенов (1 Eth (~500$) / 20 = ~25$) (цену можно изменить во время ICO)\n', '    - Минимальная и максимальная сумма покупки: 1 ETH и 10 000 ETH\n', '    - Токенов на продажу 20 000 000 (50%)\n', '    - 20 000 000 (50%) токенов передается бенефициару во время создания токена\n', '    - Средства от покупки токенов передаются бенефициару\n', '    - Закрытие Crowdsale происходит с помощью функции `withdraw()`:нераскупленные токены и управление токеном передаётся бенефициару, выпуск токенов закрывается\n', '    - Измение цены токена происходет функцией `setTokenPrice(_value)`, где `_value` - кол-во токенов покумаемое за 1 Ether, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной\n', '*/\n', '\n', 'contract Token is BurnableToken, MintableToken {\n', '    string public name = "GBCoin";\n', '    string public symbol = "GBCN";\n', '    uint256 public decimals = 18;\n', '\n', '    function Token() {\n', '        MAX_SUPPLY = 40000000 * 1 ether;                                            // Maximum amount tokens\n', '        mint(0xb942E28245d39ab4482e7C9972E07325B5653642, 20000000 * 1 ether);       \n', '    }\n', '}\n', '\n', 'contract Crowdsale is Pausable {\n', '    using SafeMath for uint;\n', '\n', '    Token public token;\n', '    address public beneficiary = 0xb942E28245d39ab4482e7C9972E07325B5653642;        \n', '\n', '    uint public collectedWei;\n', '    uint public tokensSold;\n', '\n', '    uint public tokensForSale = 20000000 * 1 ether;                                 // Amount tokens for sale\n', '    uint public priceTokenWei = 1 ether / 25;                                       // 1 Eth (~875$) / 25 = ~35$\n', '\n', '    bool public crowdsaleFinished = false;\n', '\n', '    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '    event Withdraw();\n', '\n', '    function Crowdsale() {\n', '        token = new Token();\n', '    }\n', '\n', '    function() payable {\n', '        purchase();\n', '    }\n', '\n', '    function setTokenPrice(uint _value) onlyOwner whenPaused {\n', '        require(!crowdsaleFinished);\n', '        priceTokenWei = 1 ether / _value;\n', '    }\n', '    \n', '    function purchase() whenNotPaused payable {\n', '        require(!crowdsaleFinished);\n', '        require(tokensSold < tokensForSale);\n', '        require(msg.value >= 0.01 ether && msg.value <= 10000 * 1 ether);\n', '\n', '        uint sum = msg.value;\n', '        uint amount = sum.div(priceTokenWei).mul(1 ether);\n', '        uint retSum = 0;\n', '        \n', '        if(tokensSold.add(amount) > tokensForSale) {\n', '            uint retAmount = tokensSold.add(amount).sub(tokensForSale);\n', '            retSum = retAmount.mul(priceTokenWei).div(1 ether);\n', '\n', '            amount = amount.sub(retAmount);\n', '            sum = sum.sub(retSum);\n', '        }\n', '\n', '        tokensSold = tokensSold.add(amount);\n', '        collectedWei = collectedWei.add(sum);\n', '\n', '        beneficiary.transfer(sum);\n', '        token.mint(msg.sender, amount);\n', '\n', '        if(retSum > 0) {\n', '            msg.sender.transfer(retSum);\n', '        }\n', '\n', '        NewContribution(msg.sender, amount, sum);\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        require(!crowdsaleFinished);\n', '        \n', '        if(tokensForSale.sub(tokensSold) > 0) {\n', '            token.mint(beneficiary, tokensForSale.sub(tokensSold));\n', '        }\n', '\n', '        token.finishMinting();\n', '        token.transferOwnership(beneficiary);\n', '\n', '        crowdsaleFinished = true;\n', '\n', '        Withdraw();\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return token.balanceOf(_owner);\n', '    }\n', '}']