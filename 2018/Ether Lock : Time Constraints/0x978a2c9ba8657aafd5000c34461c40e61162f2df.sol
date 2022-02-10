['pragma solidity ^0.4.18;\n', '\n', 'contract DelegateERC20 {\n', '  function delegateTotalSupply() public view returns (uint256);\n', '  function delegateBalanceOf(address who) public view returns (uint256);\n', '  function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);\n', '  function delegateAllowance(address owner, address spender) public view returns (uint256);\n', '  function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);\n', '  function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);\n', '  function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);\n', '  function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);\n', '}\n', 'contract Ownable {\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  function transferOwnership(address newOwner) public;\n', '}\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  function pause() public;\n', '  function unpause() public;\n', '}\n', 'contract CanReclaimToken is Ownable {\n', '  function reclaimToken(ERC20Basic token) external;\n', '}\n', 'contract Claimable is Ownable {\n', '  function transferOwnership(address newOwner) public;\n', '  function claimOwnership() public;\n', '}\n', 'contract AddressList is Claimable {\n', '    event ChangeWhiteList(address indexed to, bool onList);\n', '    function changeList(address _to, bool _onList) public;\n', '}\n', 'contract HasNoContracts is Ownable {\n', '  function reclaimContract(address contractAddr) external;\n', '}\n', 'contract HasNoEther is Ownable {\n', '  function() external;\n', '  function reclaimEther() external;\n', '}\n', 'contract HasNoTokens is CanReclaimToken {\n', '  function tokenFallback(address from_, uint256 value_, bytes data_) external;\n', '}\n', 'contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {\n', '}\n', 'contract AllowanceSheet is Claimable {\n', '    function addAllowance(address tokenHolder, address spender, uint256 value) public;\n', '    function subAllowance(address tokenHolder, address spender, uint256 value) public;\n', '    function setAllowance(address tokenHolder, address spender, uint256 value) public;\n', '}\n', 'contract BalanceSheet is Claimable {\n', '    function addBalance(address addr, uint256 value) public;\n', '    function subBalance(address addr, uint256 value) public;\n', '    function setBalance(address addr, uint256 value) public;\n', '}\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic, Claimable {\n', '  function setBalanceSheet(address sheet) external;\n', '  function totalSupply() public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '}\n', 'contract BurnableToken is BasicToken {\n', '  event Burn(address indexed burner, uint256 value);\n', '  function burn(uint256 _value) public;\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'library SafeERC20 {\n', '}\n', 'contract StandardToken is ERC20, BasicToken {\n', '  function setAllowanceSheet(address sheet) external;\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '  function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal;\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal;\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool);\n', '  function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal;\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);\n', '  function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal;\n', '}\n', 'contract CanDelegate is StandardToken {\n', '    event DelegatedTo(address indexed newContract);\n', '    function delegateToNewContract(DelegateERC20 newContract) public;\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address _owner, address spender) public view returns (uint256);\n', '    function totalSupply() public view returns (uint256);\n', '    function increaseApproval(address spender, uint addedValue) public returns (bool);\n', '    function decreaseApproval(address spender, uint subtractedValue) public returns (bool);\n', '}\n', 'contract StandardDelegate is StandardToken, DelegateERC20 {\n', '    function setDelegatedFrom(address addr) public;\n', '    function delegateTotalSupply() public view returns (uint256);\n', '    function delegateBalanceOf(address who) public view returns (uint256);\n', '    function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);\n', '    function delegateAllowance(address owner, address spender) public view returns (uint256);\n', '    function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);\n', '    function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);\n', '    function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);\n', '    function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);\n', '}\n', 'contract PausableToken is StandardToken, Pausable {\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool success);\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);\n', '}\n', 'contract TrueUSD is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {\n', '    event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event WipedAccount(address indexed account, uint256 balance);\n', '    function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) public;\n', '    function changeName(string _name, string _symbol) public;\n', '    function burn(uint256 _value) public;\n', '    function mint(address _to, uint256 _amount) public;\n', '    function changeBurnBounds(uint newMin, uint newMax) public;\n', '    function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal;\n', '    function wipeBlacklistedAccount(address account) public;\n', '    function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256);\n', '    function changeStakingFees(uint80 _transferFeeNumerator, uint80 _transferFeeDenominator, uint80 _mintFeeNumerator, uint80 _mintFeeDenominator, uint256 _mintFeeFlat, uint80 _burnFeeNumerator, uint80 _burnFeeDenominator, uint256 _burnFeeFlat) public;\n', '    function changeStaker(address newStaker) public;\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library NewSafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = _a / _b;\n', '        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Cash311\n', ' * @dev The main contract of the project.\n', ' */\n', '  /**\n', '    * @title Cash311\n', '    * @dev https://311.cash/;\n', '    */\n', '    contract Cash311 {\n', '        // Connecting SafeMath for safe calculations.\n', '          // Подключает библиотеку безопасных вычислений к контракту.\n', '        using NewSafeMath for uint;\n', '\n', '        // A variable for address of the owner;\n', '          // Переменная для хранения адреса владельца контракта;\n', '        address owner;\n', '\n', '        // A variable for address of the ERC20 token;\n', '          // Переменная для хранения адреса токена ERC20;\n', '        TrueUSD public token = TrueUSD(0x8dd5fbce2f6a956c3022ba3663759011dd51e73e);\n', '\n', '        // A variable for decimals of the token;\n', '          // Переменная для количества знаков после запятой у токена;\n', '        uint private decimals = 10**16;\n', '\n', '        // A variable for storing deposits of investors.\n', '          // Переменная для хранения записей о сумме инвестиций инвесторов.\n', '        mapping (address => uint) deposit;\n', '        uint deposits;\n', '\n', '        // A variable for storing amount of withdrawn money of investors.\n', '          // Переменная для хранения записей о сумме снятых средств.\n', '        mapping (address => uint) withdrawn;\n', '\n', '        // A variable for storing reference point to count available money to withdraw.\n', '          // Переменная для хранения времени отчета для инвесторов.\n', '        mapping (address => uint) lastTimeWithdraw;\n', '\n', '\n', '        // RefSystem\n', '        mapping (address => uint) referals1;\n', '        mapping (address => uint) referals2;\n', '        mapping (address => uint) referals3;\n', '        mapping (address => uint) referals1m;\n', '        mapping (address => uint) referals2m;\n', '        mapping (address => uint) referals3m;\n', '        mapping (address => address) referers;\n', '        mapping (address => bool) refIsSet;\n', '        mapping (address => uint) refBonus;\n', '\n', '\n', '        // A constructor function for the contract. It used single time as contract is deployed.\n', '          // Единоразовая функция вызываемая при деплое контракта.\n', '        function Cash311() public {\n', '            // Sets an owner for the contract;\n', '              // Устанавливает владельца контракта;\n', '            owner = msg.sender;\n', '        }\n', '\n', '        // A function for transferring ownership of the contract (available only for the owner).\n', '          // Функция для переноса права владения контракта (доступна только для владельца).\n', '        function transferOwnership(address _newOwner) external {\n', '            require(msg.sender == owner);\n', '            require(_newOwner != address(0));\n', '            owner = _newOwner;\n', '        }\n', '\n', '        // RefSystem\n', '        function bytesToAddress1(bytes source) internal pure returns(address parsedReferer) {\n', '            assembly {\n', '                parsedReferer := mload(add(source,0x14))\n', '            }\n', '            return parsedReferer;\n', '        }\n', '\n', '        // A function for getting key info for investors.\n', '          // Функция для вызова ключевой информации для инвестора.\n', '        function getInfo(address _address) public view returns(uint Deposit, uint Withdrawn, uint AmountToWithdraw, uint Bonuses) {\n', '\n', '            // 1) Amount of invested tokens;\n', '              // 1) Сумма вложенных токенов;\n', '            Deposit = deposit[_address].div(decimals);\n', '            // 2) Amount of withdrawn tokens;\n', '              // 3) Сумма снятых средств;\n', '            Withdrawn = withdrawn[_address].div(decimals);\n', '            // 3) Amount of tokens which is available to withdraw;\n', '            // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit * 0.0311) / decimals / 1 period\n', '              // 4) Сумма токенов доступных к выводу;\n', '              // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита * 0.0311) / decimals / 1 period\n', '            uint _a = (block.timestamp.sub(lastTimeWithdraw[_address]).sub((block.timestamp.sub(lastTimeWithdraw[_address])).mod(1 days))).mul(deposit[_address].mul(311).div(10000)).div(1 days);\n', '            AmountToWithdraw = _a.div(decimals);\n', '            // RefSystem\n', '            Bonuses = refBonus[_address].div(decimals);\n', '        }\n', '\n', '        // RefSystem\n', '        function getRefInfo(address _address) public view returns(uint Referals1, uint Referals1m, uint Referals2, uint Referals2m, uint Referals3, uint Referals3m) {\n', '            Referals1 = referals1[_address];\n', '            Referals1m = referals1m[_address].div(decimals);\n', '            Referals2 = referals2[_address];\n', '            Referals2m = referals2m[_address].div(decimals);\n', '            Referals3 = referals3[_address];\n', '            Referals3m = referals3m[_address].div(decimals);\n', '        }\n', '\n', '        function getNumber() public view returns(uint) {\n', '            return deposits;\n', '        }\n', '\n', '        function getTime(address _address) public view returns(uint Hours, uint Minutes) {\n', '            Hours = (lastTimeWithdraw[_address] % 1 days) / 1 hours;\n', '            Minutes = (lastTimeWithdraw[_address] % 1 days) % 1 hours / 1 minutes;\n', '        }\n', '\n', '\n', '\n', '\n', '        // A "fallback" function. It is automatically being called when anybody sends ETH to the contract. Even if the amount of ETH is ecual to 0;\n', '          // Функция автоматически вызываемая при получении ETH контрактом (даже если было отправлено 0 эфиров);\n', '        function() external payable {\n', '\n', '            // If investor accidentally sent ETH then function send it back;\n', '              // Если инвестором был отправлен ETH то средства возвращаются отправителю;\n', '            msg.sender.transfer(msg.value);\n', '            // If the value of sent ETH is equal to 0 then function executes special algorithm:\n', '            // 1) Gets amount of intended deposit (approved tokens).\n', '            // 2) If there are no approved tokens then function "withdraw" is called for investors;\n', '              // Если было отправлено 0 эфиров то исполняется следующий алгоритм:\n', '              // 1) Заправшивается количество токенов для инвестирования (кол-во одобренных к выводу токенов).\n', '              // 2) Если одобрены токенов нет, для действующих инвесторов вызывается функция инвестирования (после этого действие функции прекращается);\n', '            uint _approvedTokens = token.allowance(msg.sender, address(this));\n', '            if (_approvedTokens == 0 && deposit[msg.sender] > 0) {\n', '                withdraw();\n', '                return;\n', '            // If there are some approved tokens to invest then function "invest" is called;\n', '              // Если были одобрены токены то вызывается функция инвестирования (после этого действие функции прекращается);\n', '            } else {\n', '                invest();\n', '                return;\n', '            }\n', '        }\n', '\n', '        // RefSystem\n', '        function refSystem(uint _value, address _referer) internal {\n', '            refBonus[_referer] = refBonus[_referer].add(_value.div(40));\n', '            referals1m[_referer] = referals1m[_referer].add(_value);\n', '            if (refIsSet[_referer]) {\n', '                address ref2 = referers[_referer];\n', '                refBonus[ref2] = refBonus[ref2].add(_value.div(50));\n', '                referals2m[ref2] = referals2m[ref2].add(_value);\n', '                if (refIsSet[referers[_referer]]) {\n', '                    address ref3 = referers[referers[_referer]];\n', '                    refBonus[ref3] = refBonus[ref3].add(_value.mul(3).div(200));\n', '                    referals3m[ref3] = referals3m[ref3].add(_value);\n', '                }\n', '            }\n', '        }\n', '\n', '        // RefSystem\n', '        function setRef(uint _value) internal {\n', '            address referer = bytesToAddress1(bytes(msg.data));\n', '            if (deposit[referer] > 0) {\n', '                referers[msg.sender] = referer;\n', '                refIsSet[msg.sender] = true;\n', '                referals1[referer] = referals1[referer].add(1);\n', '                if (refIsSet[referer]) {\n', '                    referals2[referers[referer]] = referals2[referers[referer]].add(1);\n', '                    if (refIsSet[referers[referer]]) {\n', '                        referals3[referers[referers[referer]]] = referals3[referers[referers[referer]]].add(1);\n', '                    }\n', '                }\n', '                refBonus[msg.sender] = refBonus[msg.sender].add(_value.div(50));\n', '                refSystem(_value, referer);\n', '            }\n', '        }\n', '\n', '\n', '\n', '        // A function which accepts tokens of investors.\n', '          // Функция для перевода токенов на контракт.\n', '        function invest() public {\n', '\n', '            // Gets amount of deposit (approved tokens);\n', '              // Заправшивает количество токенов для инвестирования (кол-во одобренных к выводу токенов);\n', '            uint _value = token.allowance(msg.sender, address(this));\n', '\n', '            // Transfers approved ERC20 tokens from investors address;\n', '              // Переводит одобренные к выводу токены ERC20 на данный контракт;\n', '            token.transferFrom(msg.sender, address(this), _value);\n', '            // Transfers a fee to the owner of the contract. The fee is 10% of the deposit (or Deposit / 10)\n', '              // Начисляет комиссию владельцу (10%);\n', '            refBonus[owner] = refBonus[owner].add(_value.div(10));\n', '\n', '            // The special algorithm for investors who increases their deposits:\n', '              // Специальный алгоритм для инвесторов увеличивающих их вклад;\n', '            if (deposit[msg.sender] > 0) {\n', '                // Amount of tokens which is available to withdraw;\n', '                // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit * 0.0311) / 1 period\n', '                  // Расчет количества токенов доступных к выводу;\n', '                  // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита * 0.0311) / 1 period\n', '                uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].mul(311).div(10000)).div(1 days);\n', '                // The additional algorithm for investors who need to withdraw available dividends:\n', '                  // Дополнительный алгоритм для инвесторов которые имеют средства к снятию;\n', '                if (amountToWithdraw != 0) {\n', '                    // Increasing the withdrawn tokens by the investor.\n', '                      // Увеличение количества выведенных средств инвестором;\n', '                    withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);\n', '                    // Transferring available dividends to the investor.\n', '                      // Перевод доступных к выводу средств на кошелек инвестора;\n', '                    token.transfer(msg.sender, amountToWithdraw);\n', '\n', '                    // RefSystem\n', '                    uint _bonus = refBonus[msg.sender];\n', '                    if (_bonus != 0) {\n', '                        refBonus[msg.sender] = 0;\n', '                        token.transfer(msg.sender, _bonus);\n', '                        withdrawn[msg.sender] = withdrawn[msg.sender].add(_bonus);\n', '                    }\n', '\n', '                }\n', '                // Setting the reference point to the current time.\n', '                  // Установка нового отчетного времени для инвестора;\n', '                lastTimeWithdraw[msg.sender] = block.timestamp;\n', '                // Increasing of the deposit of the investor.\n', '                  // Увеличение Суммы депозита инвестора;\n', '                deposit[msg.sender] = deposit[msg.sender].add(_value);\n', '                // End of the function for investors who increases their deposits.\n', '                  // Конец функции для инвесторов увеличивающих свои депозиты;\n', '\n', '                // RefSystem\n', '                if (refIsSet[msg.sender]) {\n', '                      refSystem(_value, referers[msg.sender]);\n', '                  } else if (msg.data.length == 20) {\n', '                      setRef(_value);\n', '                  }\n', '                return;\n', '            }\n', '            // The algorithm for new investors:\n', '            // Setting the reference point to the current time.\n', '              // Алгоритм для новых инвесторов:\n', '              // Установка нового отчетного времени для инвестора;\n', '            lastTimeWithdraw[msg.sender] = block.timestamp;\n', '            // Storing the amount of the deposit for new investors.\n', '            // Установка суммы внесенного депозита;\n', '            deposit[msg.sender] = (_value);\n', '            deposits += 1;\n', '\n', '            // RefSystem\n', '            if (refIsSet[msg.sender]) {\n', '                refSystem(_value, referers[msg.sender]);\n', '            } else if (msg.data.length == 20) {\n', '                setRef(_value);\n', '            }\n', '        }\n', '\n', '        // A function for getting available dividends of the investor.\n', '          // Функция для вывода средств доступных к снятию;\n', '        function withdraw() public {\n', '\n', '            // Amount of tokens which is available to withdraw.\n', '            // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit * 0.0311) / 1 period\n', '              // Расчет количества токенов доступных к выводу;\n', '              // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита * 0.0311) / 1 period\n', '            uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].mul(311).div(10000)).div(1 days);\n', '            // Reverting the whole function for investors who got nothing to withdraw yet.\n', '              // В случае если к выводу нет средств то функция отменяется;\n', '            if (amountToWithdraw == 0) {\n', '                revert();\n', '            }\n', '            // Increasing the withdrawn tokens by the investor.\n', '              // Увеличение количества выведенных средств инвестором;\n', '            withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);\n', '            // Updating the reference point.\n', '            // Formula without SafeMath: Current Time - ((Current Time - Previous Reference Point) % 1 period)\n', '              // Обновление отчетного времени инвестора;\n', '              // Формула без библиотеки безопасных вычислений: Текущее время - ((Текущее время - Предыдущее отчетное время) % 1 period)\n', '            lastTimeWithdraw[msg.sender] = block.timestamp.sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days));\n', '            // Transferring the available dividends to the investor.\n', '              // Перевод выведенных средств;\n', '            token.transfer(msg.sender, amountToWithdraw);\n', '\n', '            // RefSystem\n', '            uint _bonus = refBonus[msg.sender];\n', '            if (_bonus != 0) {\n', '                refBonus[msg.sender] = 0;\n', '                token.transfer(msg.sender, _bonus);\n', '                withdrawn[msg.sender] = withdrawn[msg.sender].add(_bonus);\n', '            }\n', '\n', '        }\n', '    }']