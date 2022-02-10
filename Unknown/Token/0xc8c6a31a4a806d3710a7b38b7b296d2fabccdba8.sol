['pragma solidity ^0.4.10;\n', '\n', '// Elixir (ELIX)\n', '\n', 'contract elixir {\n', '    \n', 'string public name; \n', 'string public symbol; \n', 'uint8 public decimals;\n', 'uint256 public totalSupply;\n', '  \n', '// Balances for each account\n', 'mapping(address => uint256) balances;\n', '\n', 'bool public balanceImportsComplete;\n', '\n', 'address exorAddress;\n', 'address devAddress;\n', '\n', '// Events\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '// Owner of account approves the transfer of an amount to another account\n', 'mapping(address => mapping (address => uint256)) allowed;\n', '  \n', 'function elixir() {\n', '    name = "elixir";\n', '    symbol = "ELIX";\n', '    decimals = 18;\n', '    devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B;\n', '    exorAddress=0x898bF39cd67658bd63577fB00A2A3571dAecbC53;\n', '}\n', '\n', 'function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '}\n', '\n', '// Transfer the balance from owner&#39;s account to another account\n', 'function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    if (balances[msg.sender] >= _amount \n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount); \n', '        return true;\n', '    } else {\n', '        return false;\n', '    }\n', '}\n', '\n', 'function createAmountFromEXORForAddress(uint256 amount,address addressProducing) public {\n', '    if (msg.sender==exorAddress) {\n', '        //extra auth\n', '        elixor EXORContract=elixor(exorAddress);\n', '        if (EXORContract.returnAmountOfELIXAddressCanProduce(addressProducing)==amount){\n', '            // They are burning EXOR to make ELIX\n', '            balances[addressProducing]+=amount;\n', '            totalSupply+=amount;\n', '        }\n', '    }\n', '}\n', '\n', 'function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _amount\n', ') returns (bool success) {\n', '    if (balances[_from] >= _amount\n', '        && allowed[_from][msg.sender] >= _amount\n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '        balances[_from] -= _amount;\n', '        allowed[_from][msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        return true;\n', '    } else {\n', '        return false;\n', '    }\n', '}\n', '\n', '// Locks up all changes to balances\n', 'function lockBalanceChanges() {\n', '    if (tx.origin==devAddress) { // Dev address\n', '       balanceImportsComplete=true;\n', '   }\n', '}\n', '\n', '// Devs will upload balances snapshot of blockchain via this function.\n', 'function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '           for (uint256 i=0;i<addressesToAddTo.length;i++)  {\n', '                address addressToAddTo=addressesToAddTo[i];\n', '                uint256 amount=amounts[i];\n', '                balances[addressToAddTo]+=amount;\n', '                totalSupply+=amount;\n', '           }\n', '       }\n', '   }\n', '}\n', '\n', '// Extra balance removal in case any issues arise. Do not anticipate using this function.\n', 'function removeAmountForAddresses(uint256[] amounts,address[] addressesToRemoveFrom) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '           for (uint256 i=0;i<addressesToRemoveFrom.length;i++)  {\n', '                address addressToRemoveFrom=addressesToRemoveFrom[i];\n', '                uint256 amount=amounts[i];\n', '                balances[addressToRemoveFrom]-=amount;\n', '                totalSupply-=amount;\n', '           }\n', '       }\n', '   }\n', '}\n', '\n', '// Manual override for total supply in case any issues arise. Do not anticipate using this function.\n', 'function removeFromTotalSupply(uint256 amount) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '            totalSupply-=amount;\n', '       }\n', '   }\n', '}\n', '\n', '\n', '// Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '// If this function is called again it overwrites the current allowance with _value.\n', 'function approve(address _spender, uint256 _amount) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '}\n', '}\n', '\n', 'contract elixor {\n', '    function returnAmountOfELIXAddressCanProduce(address producingAddress) public returns(uint256);\n', '}']
['pragma solidity ^0.4.10;\n', '\n', '// Elixir (ELIX)\n', '\n', 'contract elixir {\n', '    \n', 'string public name; \n', 'string public symbol; \n', 'uint8 public decimals;\n', 'uint256 public totalSupply;\n', '  \n', '// Balances for each account\n', 'mapping(address => uint256) balances;\n', '\n', 'bool public balanceImportsComplete;\n', '\n', 'address exorAddress;\n', 'address devAddress;\n', '\n', '// Events\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '// Owner of account approves the transfer of an amount to another account\n', 'mapping(address => mapping (address => uint256)) allowed;\n', '  \n', 'function elixir() {\n', '    name = "elixir";\n', '    symbol = "ELIX";\n', '    decimals = 18;\n', '    devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B;\n', '    exorAddress=0x898bF39cd67658bd63577fB00A2A3571dAecbC53;\n', '}\n', '\n', 'function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '}\n', '\n', "// Transfer the balance from owner's account to another account\n", 'function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    if (balances[msg.sender] >= _amount \n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount); \n', '        return true;\n', '    } else {\n', '        return false;\n', '    }\n', '}\n', '\n', 'function createAmountFromEXORForAddress(uint256 amount,address addressProducing) public {\n', '    if (msg.sender==exorAddress) {\n', '        //extra auth\n', '        elixor EXORContract=elixor(exorAddress);\n', '        if (EXORContract.returnAmountOfELIXAddressCanProduce(addressProducing)==amount){\n', '            // They are burning EXOR to make ELIX\n', '            balances[addressProducing]+=amount;\n', '            totalSupply+=amount;\n', '        }\n', '    }\n', '}\n', '\n', 'function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _amount\n', ') returns (bool success) {\n', '    if (balances[_from] >= _amount\n', '        && allowed[_from][msg.sender] >= _amount\n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '        balances[_from] -= _amount;\n', '        allowed[_from][msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        return true;\n', '    } else {\n', '        return false;\n', '    }\n', '}\n', '\n', '// Locks up all changes to balances\n', 'function lockBalanceChanges() {\n', '    if (tx.origin==devAddress) { // Dev address\n', '       balanceImportsComplete=true;\n', '   }\n', '}\n', '\n', '// Devs will upload balances snapshot of blockchain via this function.\n', 'function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '           for (uint256 i=0;i<addressesToAddTo.length;i++)  {\n', '                address addressToAddTo=addressesToAddTo[i];\n', '                uint256 amount=amounts[i];\n', '                balances[addressToAddTo]+=amount;\n', '                totalSupply+=amount;\n', '           }\n', '       }\n', '   }\n', '}\n', '\n', '// Extra balance removal in case any issues arise. Do not anticipate using this function.\n', 'function removeAmountForAddresses(uint256[] amounts,address[] addressesToRemoveFrom) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '           for (uint256 i=0;i<addressesToRemoveFrom.length;i++)  {\n', '                address addressToRemoveFrom=addressesToRemoveFrom[i];\n', '                uint256 amount=amounts[i];\n', '                balances[addressToRemoveFrom]-=amount;\n', '                totalSupply-=amount;\n', '           }\n', '       }\n', '   }\n', '}\n', '\n', '// Manual override for total supply in case any issues arise. Do not anticipate using this function.\n', 'function removeFromTotalSupply(uint256 amount) public {\n', '   if (tx.origin==devAddress) { // Dev address\n', '       if (!balanceImportsComplete)  {\n', '            totalSupply-=amount;\n', '       }\n', '   }\n', '}\n', '\n', '\n', '// Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '// If this function is called again it overwrites the current allowance with _value.\n', 'function approve(address _spender, uint256 _amount) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '}\n', '}\n', '\n', 'contract elixor {\n', '    function returnAmountOfELIXAddressCanProduce(address producingAddress) public returns(uint256);\n', '}']