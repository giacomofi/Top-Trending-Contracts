['pragma solidity ^0.4.16;\n', '\n', 'contract SafeMath {\n', '\n', '    function safeAdd(uint256 x, uint256 y) view internal returns (uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) view internal returns (uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) view internal returns (uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0) || (z / x == y));\n', '        return z;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) view internal returns (uint256) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Owner {\n', '\t\n', '\t// Адреса владельцев\n', '\tmapping ( address => bool ) public ownerAddressMap;\n', '\t// Соответсвие адреса владельца и его номера\n', '\tmapping ( address => uint256 ) public ownerAddressNumberMap;\n', '\t// список менеджеров\n', '\tmapping ( uint256 => address ) public ownerListMap;\n', '\t// сколько всего менеджеров\n', '\tuint256 public ownerCountInt = 0;\n', '\t\n', '\t// событие "изменение в контракте"\n', '\tevent ContractManagementUpdate( string _type, address _initiator, address _to, bool _newvalue );\n', '\n', '\t// модификатор - если смотрит владелец\n', '\tmodifier isOwner {\n', '        require( ownerAddressMap[msg.sender]==true );\n', '        _;\n', '    }\n', '\t\n', '\t// создание/включение владельца\n', '\tfunction ownerOn( address _onOwnerAddress ) external isOwner returns (bool retrnVal) {\n', "\t\t// Check if it's a non-zero address\n", '\t\trequire( _onOwnerAddress != address(0) );\n', '\t\t// если такой владелец есть (стартового владельца удалить нельзя)\n', '\t\tif ( ownerAddressNumberMap[ _onOwnerAddress ]>0 )\n', '\t\t{\n', '\t\t\t// если такой владелец отключен, влючим его обратно\n', '\t\t\tif ( !ownerAddressMap[ _onOwnerAddress ] )\n', '\t\t\t{\n', '\t\t\t\townerAddressMap[ _onOwnerAddress ] = true;\n', '\t\t\t\tContractManagementUpdate( "Owner", msg.sender, _onOwnerAddress, true );\n', '\t\t\t\tretrnVal = true;\n', '\t\t\t}\n', '\t\t\telse\n', '\t\t\t{\n', '\t\t\t\tretrnVal = false;\n', '\t\t\t}\n', '\t\t}\n', '\t\t// если такого владеьца нет\n', '\t\telse\n', '\t\t{\n', '\t\t\townerAddressMap[ _onOwnerAddress ] = true;\n', '\t\t\townerAddressNumberMap[ _onOwnerAddress ] = ownerCountInt;\n', '\t\t\townerListMap[ ownerCountInt ] = _onOwnerAddress;\n', '\t\t\townerCountInt++;\n', '\t\t\tContractManagementUpdate( "Owner", msg.sender, _onOwnerAddress, true );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t}\n', '\t\n', '\t// отключение менеджера\n', '\tfunction ownerOff( address _offOwnerAddress ) external isOwner returns (bool retrnVal) {\n', '\t\t// если такой менеджер есть и он не 0-вой, а также активен\n', '\t\t// 0-вой менеджер не может быть отключен\n', '\t\tif ( ownerAddressNumberMap[ _offOwnerAddress ]>0 && ownerAddressMap[ _offOwnerAddress ] )\n', '\t\t{\n', '\t\t\townerAddressMap[ _offOwnerAddress ] = false;\n', '\t\t\tContractManagementUpdate( "Owner", msg.sender, _offOwnerAddress, false );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\tretrnVal = false;\n', '\t\t}\n', '\t}\n', '\n', '\t// конструктор, при создании контракта добалвяет создателя в "неудаляемые" создатели\n', '\tfunction Owner() public {\n', '\t\t// создаем владельца\n', '\t\townerAddressMap[ msg.sender ] = true;\n', '\t\townerAddressNumberMap[ msg.sender ] = ownerCountInt;\n', '\t\townerListMap[ ownerCountInt ] = msg.sender;\n', '\t\townerCountInt++;\n', '\t}\n', '}\n', '\n', 'contract SpecialManager is Owner {\n', '\n', '\t// адреса специальных менеджеров\n', '\tmapping ( address => bool ) public specialManagerAddressMap;\n', '\t// Соответсвие адреса специального менеджера и его номера\n', '\tmapping ( address => uint256 ) public specialManagerAddressNumberMap;\n', '\t// список специальноых менеджеров\n', '\tmapping ( uint256 => address ) public specialManagerListMap;\n', '\t// сколько всего специальных менеджеров\n', '\tuint256 public specialManagerCountInt = 0;\n', '\t\n', '\t// модификатор - если смотрит владелец или специальный менеджер\n', '\tmodifier isSpecialManagerOrOwner {\n', '        require( specialManagerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );\n', '        _;\n', '    }\n', '\t\n', '\t// создание/включение специального менеджера\n', '\tfunction specialManagerOn( address _onSpecialManagerAddress ) external isOwner returns (bool retrnVal) {\n', "\t\t// Check if it's a non-zero address\n", '\t\trequire( _onSpecialManagerAddress != address(0) );\n', '\t\t// если такой менеджер есть\n', '\t\tif ( specialManagerAddressNumberMap[ _onSpecialManagerAddress ]>0 )\n', '\t\t{\n', '\t\t\t// если такой менеджер отключен, влючим его обратно\n', '\t\t\tif ( !specialManagerAddressMap[ _onSpecialManagerAddress ] )\n', '\t\t\t{\n', '\t\t\t\tspecialManagerAddressMap[ _onSpecialManagerAddress ] = true;\n', '\t\t\t\tContractManagementUpdate( "Special Manager", msg.sender, _onSpecialManagerAddress, true );\n', '\t\t\t\tretrnVal = true;\n', '\t\t\t}\n', '\t\t\telse\n', '\t\t\t{\n', '\t\t\t\tretrnVal = false;\n', '\t\t\t}\n', '\t\t}\n', '\t\t// если такого менеджера нет\n', '\t\telse\n', '\t\t{\n', '\t\t\tspecialManagerAddressMap[ _onSpecialManagerAddress ] = true;\n', '\t\t\tspecialManagerAddressNumberMap[ _onSpecialManagerAddress ] = specialManagerCountInt;\n', '\t\t\tspecialManagerListMap[ specialManagerCountInt ] = _onSpecialManagerAddress;\n', '\t\t\tspecialManagerCountInt++;\n', '\t\t\tContractManagementUpdate( "Special Manager", msg.sender, _onSpecialManagerAddress, true );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t}\n', '\t\n', '\t// отключение менеджера\n', '\tfunction specialManagerOff( address _offSpecialManagerAddress ) external isOwner returns (bool retrnVal) {\n', '\t\t// если такой менеджер есть и он не 0-вой, а также активен\n', '\t\t// 0-вой менеджер не может быть отключен\n', '\t\tif ( specialManagerAddressNumberMap[ _offSpecialManagerAddress ]>0 && specialManagerAddressMap[ _offSpecialManagerAddress ] )\n', '\t\t{\n', '\t\t\tspecialManagerAddressMap[ _offSpecialManagerAddress ] = false;\n', '\t\t\tContractManagementUpdate( "Special Manager", msg.sender, _offSpecialManagerAddress, false );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\tretrnVal = false;\n', '\t\t}\n', '\t}\n', '\n', '\n', '\t// конструктор, добавляет создателя в суперменеджеры\n', '\tfunction SpecialManager() public {\n', '\t\t// создаем менеджера\n', '\t\tspecialManagerAddressMap[ msg.sender ] = true;\n', '\t\tspecialManagerAddressNumberMap[ msg.sender ] = specialManagerCountInt;\n', '\t\tspecialManagerListMap[ specialManagerCountInt ] = msg.sender;\n', '\t\tspecialManagerCountInt++;\n', '\t}\n', '}\n', '\n', 'contract Manager is SpecialManager {\n', '\t\n', '\t// адрес менеджеров\n', '\tmapping ( address => bool ) public managerAddressMap;\n', '\t// Соответсвие адреса менеджеров и его номера\n', '\tmapping ( address => uint256 ) public managerAddressNumberMap;\n', '\t// список менеджеров\n', '\tmapping ( uint256 => address ) public managerListMap;\n', '\t// сколько всего менеджеров\n', '\tuint256 public managerCountInt = 0;\n', '\t\n', '\t// модификатор - если смотрит владелец или менеджер\n', '\tmodifier isManagerOrOwner {\n', '        require( managerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );\n', '        _;\n', '    }\n', '\t\n', '\t// создание/включение менеджера\n', '\tfunction managerOn( address _onManagerAddress ) external isOwner returns (bool retrnVal) {\n', "\t\t// Check if it's a non-zero address\n", '\t\trequire( _onManagerAddress != address(0) );\n', '\t\t// если такой менеджер есть\n', '\t\tif ( managerAddressNumberMap[ _onManagerAddress ]>0 )\n', '\t\t{\n', '\t\t\t// если такой менеджер отключен, влючим его обратно\n', '\t\t\tif ( !managerAddressMap[ _onManagerAddress ] )\n', '\t\t\t{\n', '\t\t\t\tmanagerAddressMap[ _onManagerAddress ] = true;\n', '\t\t\t\tContractManagementUpdate( "Manager", msg.sender, _onManagerAddress, true );\n', '\t\t\t\tretrnVal = true;\n', '\t\t\t}\n', '\t\t\telse\n', '\t\t\t{\n', '\t\t\t\tretrnVal = false;\n', '\t\t\t}\n', '\t\t}\n', '\t\t// если такого менеджера нет\n', '\t\telse\n', '\t\t{\n', '\t\t\tmanagerAddressMap[ _onManagerAddress ] = true;\n', '\t\t\tmanagerAddressNumberMap[ _onManagerAddress ] = managerCountInt;\n', '\t\t\tmanagerListMap[ managerCountInt ] = _onManagerAddress;\n', '\t\t\tmanagerCountInt++;\n', '\t\t\tContractManagementUpdate( "Manager", msg.sender, _onManagerAddress, true );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t}\n', '\t\n', '\t// отключение менеджера\n', '\tfunction managerOff( address _offManagerAddress ) external isOwner returns (bool retrnVal) {\n', '\t\t// если такой менеджер есть и он не 0-вой, а также активен\n', '\t\t// 0-вой менеджер не может быть отключен\n', '\t\tif ( managerAddressNumberMap[ _offManagerAddress ]>0 && managerAddressMap[ _offManagerAddress ] )\n', '\t\t{\n', '\t\t\tmanagerAddressMap[ _offManagerAddress ] = false;\n', '\t\t\tContractManagementUpdate( "Manager", msg.sender, _offManagerAddress, false );\n', '\t\t\tretrnVal = true;\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\tretrnVal = false;\n', '\t\t}\n', '\t}\n', '\n', '\n', '\t// конструктор, добавляет создателя в менеджеры\n', '\tfunction Manager() public {\n', '\t\t// создаем менеджера\n', '\t\tmanagerAddressMap[ msg.sender ] = true;\n', '\t\tmanagerAddressNumberMap[ msg.sender ] = managerCountInt;\n', '\t\tmanagerListMap[ managerCountInt ] = msg.sender;\n', '\t\tmanagerCountInt++;\n', '\t}\n', '}\n', '\n', 'contract Management is Manager {\n', '\t\n', '\t// текстовое описание контракта\n', '\tstring public description = "";\n', '\t\n', '\t// текущий статус разрешения транзакций\n', '\t// TRUE - транзакции возможны\n', '\t// FALSE - транзакции не возможны\n', '\tbool public transactionsOn = false;\n', '\t\n', '\t// текущий статус эмиссии\n', '\t// TRUE - эмиссия возможна, менеджеры могут добавлять в контракт токены\n', '\t// FALSE - эмиссия невозможна, менеджеры не могут добавлять в контракт токены\n', '\tbool public emissionOn = true;\n', '\n', '\t// потолок эмиссии\n', '\tuint256 public tokenCreationCap = 0;\n', '\t\n', '\t// модификатор - транзакции возможны\n', '\tmodifier isTransactionsOn{\n', '        require( transactionsOn );\n', '        _;\n', '    }\n', '\t\n', '\t// модификатор - эмиссия возможна\n', '\tmodifier isEmissionOn{\n', '        require( emissionOn );\n', '        _;\n', '    }\n', '\t\n', '\t// функция изменения статуса транзакций\n', '\tfunction transactionsStatusUpdate( bool _on ) external isOwner\n', '\t{\n', '\t\ttransactionsOn = _on;\n', '\t}\n', '\t\n', '\t// функция изменения статуса эмиссии\n', '\tfunction emissionStatusUpdate( bool _on ) external isOwner\n', '\t{\n', '\t\temissionOn = _on;\n', '\t}\n', '\t\n', '\t// установка потолка эмиссии\n', '\tfunction tokenCreationCapUpdate( uint256 _newVal ) external isOwner\n', '\t{\n', '\t\ttokenCreationCap = _newVal;\n', '\t}\n', '\t\n', '\t// событие, "смена описания"\n', '\tevent DescriptionPublished( string _description, address _initiator);\n', '\t\n', '\t// изменение текста\n', '\tfunction descriptionUpdate( string _newVal ) external isOwner\n', '\t{\n', '\t\tdescription = _newVal;\n', '\t\tDescriptionPublished( _newVal, msg.sender );\n', '\t}\n', '}\n', '\n', '// Токен-контракт FoodCoin Ecosystem\n', 'contract FoodcoinEcosystem is SafeMath, Management {\n', '\t\n', '\t// название токена\n', '\tstring public constant name = "FoodCoin EcoSystem";\n', '\t// короткое название токена\n', '\tstring public constant symbol = "FOOD";\n', '\t// точность токена (знаков после запятой для вывода в кошельках)\n', '\tuint256 public constant decimals = 8;\n', '\t// общее кол-во выпущенных токенов\n', '\tuint256 public totalSupply = 0;\n', '\t\n', '\t// состояние счета\n', '\tmapping ( address => uint256 ) balances;\n', '\t// список всех счетов\n', '\tmapping ( uint256 => address ) public balancesListAddressMap;\n', '\t// соответсвие счета и его номера\n', '\tmapping ( address => uint256 ) public balancesListNumberMap;\n', '\t// текстовое описание счета\n', '\tmapping ( address => string ) public balancesAddressDescription;\n', '\t// общее кол-во всех счетов\n', '\tuint256 balancesCountInt = 1;\n', '\t\n', '\t// делегирование на управление счетом на определенную сумму\n', '\tmapping ( address => mapping ( address => uint256 ) ) allowed;\n', '\t\n', '\t\n', '\t// событие - транзакция\n', '\tevent Transfer(address _from, address _to, uint256 _value, address _initiator);\n', '\t\n', '\t// событие делегирование управления счетом\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '\t// событие - эмиссия\n', '\tevent TokenEmissionEvent( address initiatorAddress, uint256 amount, bool emissionOk );\n', '\t\n', '\t// событие - списание средств\n', '\tevent WithdrawEvent( address initiatorAddress, address toAddress, bool withdrawOk, uint256 withdrawValue, uint256 newBalancesValue );\n', '\t\n', '\t\n', '\t// проссмотра баланса счета\n', '\tfunction balanceOf( address _owner ) external view returns ( uint256 )\n', '\t{\n', '\t\treturn balances[ _owner ];\n', '\t}\n', '\t// Check if a given user has been delegated rights to perform transfers on behalf of the account owner\n', '\tfunction allowance( address _owner, address _initiator ) external view returns ( uint256 remaining )\n', '\t{\n', '\t\treturn allowed[ _owner ][ _initiator ];\n', '\t}\n', '\t// общее кол-во счетов\n', '\tfunction balancesQuantity() external view returns ( uint256 )\n', '\t{\n', '\t\treturn balancesCountInt - 1;\n', '\t}\n', '\t\n', '\t// функция непосредственного перевода токенов. Если это первое получение средств для какого-то счета, то также создается детальная информация по этому счету\n', '\tfunction _addClientAddress( address _balancesAddress, uint256 _amount ) internal\n', '\t{\n', '\t\t// check if this address is not on the list yet\n', '\t\tif ( balancesListNumberMap[ _balancesAddress ] == 0 )\n', '\t\t{\n', '\t\t\t// add it to the list\n', '\t\t\tbalancesListAddressMap[ balancesCountInt ] = _balancesAddress;\n', '\t\t\tbalancesListNumberMap[ _balancesAddress ] = balancesCountInt;\n', '\t\t\t// increment account counter\n', '\t\t\tbalancesCountInt++;\n', '\t\t}\n', '\t\t// add tokens to the account \n', '\t\tbalances[ _balancesAddress ] = safeAdd( balances[ _balancesAddress ], _amount );\n', '\t}\n', '\t// Internal function that performs the actual transfer (cannot be called externally)\n', '\tfunction _transfer( address _from, address _to, uint256 _value ) internal isTransactionsOn returns ( bool success )\n', '\t{\n', '\t\t// If the amount to transfer is greater than 0, and sender has funds available\n', '\t\tif ( _value > 0 && balances[ _from ] >= _value )\n', '\t\t{\n', '\t\t\t// Subtract from sender account\n', '\t\t\tbalances[ _from ] -= _value;\n', "\t\t\t// Add to receiver's account\n", '\t\t\t_addClientAddress( _to, _value );\n', '\t\t\t// Perform the transfer\n', '\t\t\tTransfer( _from, _to, _value, msg.sender );\n', '\t\t\t// Successfully completed transfer\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\t// Return false if there are problems\n', '\t\telse\n', '\t\t{\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\t// функция перевода токенов\n', '\tfunction transfer(address _to, uint256 _value) external isTransactionsOn returns ( bool success )\n', '\t{\n', '\t\treturn _transfer( msg.sender, _to, _value );\n', '\t}\n', '\t// функция перевода токенов с делегированного счета\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) external isTransactionsOn returns ( bool success )\n', '\t{\n', "\t\t// Check if the transfer initiator has permissions to move funds from the sender's account\n", '\t\tif ( allowed[_from][msg.sender] >= _value )\n', '\t\t{\n', '\t\t\t// If yes - perform transfer \n', '\t\t\tif ( _transfer( _from, _to, _value ) )\n', '\t\t\t{\n', '\t\t\t\t// Decrease the total amount that initiator has permissions to access\n', '\t\t\t\tallowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);\n', '\t\t\t\treturn true;\n', '\t\t\t}\n', '\t\t\telse\n', '\t\t\t{\n', '\t\t\t\treturn false;\n', '\t\t\t}\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\t// функция делегирования управления счетом на определенную сумму\n', '\tfunction approve( address _initiator, uint256 _value ) external isTransactionsOn returns ( bool success )\n', '\t{\n', '\t\t// Grant the rights for a certain amount of tokens only\n', '\t\tallowed[ msg.sender ][ _initiator ] = _value;\n', '\t\t// Initiate the Approval event\n', '\t\tApproval( msg.sender, _initiator, _value );\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\t// функция эмиссии (менеджер или владелец контракта создает токены и отправляет их на определенный счет)\n', '\tfunction tokenEmission(address _reciever, uint256 _amount) external isManagerOrOwner isEmissionOn returns ( bool returnVal )\n', '\t{\n', "\t\t// Check if it's a non-zero address\n", '\t\trequire( _reciever != address(0) );\n', '\t\t// Calculate number of tokens after generation\n', '\t\tuint256 checkedSupply = safeAdd( totalSupply, _amount );\n', '\t\t// сумма к эмиссии\n', '\t\tuint256 amountTmp = _amount;\n', '\t\t// Если потолок эмиссии установлен, то нельзя выпускать больше этого потолка\n', '\t\tif ( tokenCreationCap > 0 && tokenCreationCap < checkedSupply )\n', '\t\t{\n', '\t\t\tamountTmp = 0;\n', '\t\t}\n', '\t\t// если попытка добавить больше 0-ля токенов\n', '\t\tif ( amountTmp > 0 )\n', '\t\t{\n', '\t\t\t// If no error, add generated tokens to a given address\n', '\t\t\t_addClientAddress( _reciever, amountTmp );\n', '\t\t\t// increase total supply of tokens\n', '\t\t\ttotalSupply = checkedSupply;\n', '\t\t\tTokenEmissionEvent( msg.sender, _amount, true);\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\treturnVal = false;\n', '\t\t\tTokenEmissionEvent( msg.sender, _amount, false);\n', '\t\t}\n', '\t}\n', '\t\n', '\t// функция списания токенов\n', '\tfunction withdraw( address _to, uint256 _amount ) external isSpecialManagerOrOwner returns ( bool returnVal, uint256 withdrawValue, uint256 newBalancesValue )\n', '\t{\n', '\t\t// check if this is a valid account\n', '\t\tif ( balances[ _to ] > 0 )\n', '\t\t{\n', '\t\t\t// сумма к списанию\n', '\t\t\tuint256 amountTmp = _amount;\n', '\t\t\t// нельзя списать больше, чем есть на счету\n', '\t\t\tif ( balances[ _to ] < _amount )\n', '\t\t\t{\n', '\t\t\t\tamountTmp = balances[ _to ];\n', '\t\t\t}\n', '\t\t\t// проводим списывание\n', '\t\t\tbalances[ _to ] = safeSubtract( balances[ _to ], amountTmp );\n', '\t\t\t// меняем текущее общее кол-во токенов\n', '\t\t\ttotalSupply = safeSubtract( totalSupply, amountTmp );\n', '\t\t\t// возвращаем ответ\n', '\t\t\treturnVal = true;\n', '\t\t\twithdrawValue = amountTmp;\n', '\t\t\tnewBalancesValue = balances[ _to ];\n', '\t\t\tWithdrawEvent( msg.sender, _to, true, amountTmp, balances[ _to ] );\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\treturnVal = false;\n', '\t\t\twithdrawValue = 0;\n', '\t\t\tnewBalancesValue = 0;\n', '\t\t\tWithdrawEvent( msg.sender, _to, false, _amount, balances[ _to ] );\n', '\t\t}\n', '\t}\n', '\t\n', '\t// добавление описания к счету\n', '\tfunction balancesAddressDescriptionUpdate( string _newDescription ) external returns ( bool returnVal )\n', '\t{\n', '\t\t// если такой аккаунт есть или владелец контракта\n', '\t\tif ( balancesListNumberMap[ msg.sender ] > 0 || ownerAddressMap[msg.sender]==true )\n', '\t\t{\n', '\t\t\tbalancesAddressDescription[ msg.sender ] = _newDescription;\n', '\t\t\treturnVal = true;\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\treturnVal = false;\n', '\t\t}\n', '\t}\n', '}']