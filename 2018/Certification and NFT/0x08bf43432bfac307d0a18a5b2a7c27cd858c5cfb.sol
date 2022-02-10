['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', ' * Базовый контракт, который поддерживает остановку продаж\n', ' */\n', '\n', 'contract Haltable is Ownable {\n', '    bool public halted;\n', '\n', '    modifier stopInEmergency {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    /* Модификатор, который вызывается в потомках */\n', '    modifier onlyInEmergency {\n', '        require(halted);\n', '        _;\n', '    }\n', '\n', '    /* Вызов функции прервет продажи, вызывать может только владелец */\n', '    function halt() external onlyOwner {\n', '        halted = true;\n', '    }\n', '\n', '    /* Вызов возвращает режим продаж */\n', '    function unhalt() external onlyOwner onlyInEmergency {\n', '        halted = false;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', 'uint256 public totalSupply;\n', 'function balanceOf(address who) constant returns (uint256);\n', 'function transfer(address to, uint256 value) returns (bool);\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * Интерфейс контракта токена\n', ' */\n', '\n', 'contract ImpToken is ERC20Basic {\n', '    function decimals() public returns (uint) {}\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/* Контракт продаж */\n', '\n', 'contract Sale is Haltable {\n', '    using SafeMath for uint;\n', '\n', '    /* Токен, который продаем */\n', '    ImpToken public impToken;\n', '\n', '    /* Собранные средства будут переводиться сюда */\n', '    address public destinationWallet;\n', '\n', '    /*  Сколько сейчас стоит 1 IMP в wei */\n', '    uint public oneImpInWei;\n', '\n', '    /*  Минимальное кол-во токенов, которое можно продать */\n', '    uint public minBuyTokenAmount;\n', '\n', '    /*  Максимальное кол-во токенов, которое можно купить за 1 раз */\n', '    uint public maxBuyTokenAmount;\n', '\n', '    /* Событие покупки токена */\n', '    event Invested(address receiver, uint weiAmount, uint tokenAmount);\n', '\n', '    /* Конструктор */\n', '    function Sale(address _impTokenAddress, address _destinationWallet) {\n', '        require(_impTokenAddress != 0);\n', '        require(_destinationWallet != 0);\n', '\n', '        impToken = ImpToken(_impTokenAddress);\n', '\n', '        destinationWallet = _destinationWallet;\n', '    }\n', '\n', '    /**\n', '     * Fallback функция вызывающаяся при переводе эфира\n', '     */\n', '    function() payable stopInEmergency {\n', '        uint weiAmount = msg.value;\n', '        address receiver = msg.sender;\n', '\n', '        uint tokenMultiplier = 10 ** impToken.decimals();\n', '        uint tokenAmount = weiAmount.mul(tokenMultiplier).div(oneImpInWei);\n', '\n', '        require(tokenAmount > 0);\n', '\n', '        require(tokenAmount >= minBuyTokenAmount && tokenAmount <= maxBuyTokenAmount);\n', '\n', '        // Сколько осталось токенов на контракте продаж\n', '        uint tokensLeft = getTokensLeft();\n', '\n', '        require(tokensLeft > 0);\n', '\n', '        require(tokenAmount <= tokensLeft);\n', '\n', '        // Переводим токены инвестору\n', '        assignTokens(receiver, tokenAmount);\n', '\n', '        // Шлем на кошелёк эфир\n', '        destinationWallet.transfer(weiAmount);\n', '\n', '        // Вызываем событие\n', '        Invested(receiver, weiAmount, tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * Адрес кошелька для сбора средств\n', '     */\n', '    function setDestinationWallet(address destinationAddress) external onlyOwner {\n', '        destinationWallet = destinationAddress;\n', '    }\n', '\n', '    /**\n', '     *  Минимальное кол-во токенов, которое можно продать\n', '     */\n', '    function setMinBuyTokenAmount(uint value) external onlyOwner {\n', '        minBuyTokenAmount = value;\n', '    }\n', '\n', '    /**\n', '     *  Максимальное кол-во токенов, которое можно продать\n', '     */\n', '    function setMaxBuyTokenAmount(uint value) external onlyOwner {\n', '        maxBuyTokenAmount = value;\n', '    }\n', '\n', '    /**\n', '     * Функция, которая задает текущий курс ETH в центах\n', '     */\n', '    function setOneImpInWei(uint value) external onlyOwner {\n', '        require(value > 0);\n', '\n', '        oneImpInWei = value;\n', '    }\n', '\n', '    /**\n', '     * Перевод токенов покупателю\n', '     */\n', '    function assignTokens(address receiver, uint tokenAmount) private {\n', '        impToken.transfer(receiver, tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * Возвращает кол-во нераспроданных токенов\n', '     */\n', '    function getTokensLeft() public constant returns (uint) {\n', '        return impToken.balanceOf(address(this));\n', '    }\n', '}']