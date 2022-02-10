['pragma solidity ^0.4.17;\n', '\n', 'contract LatiumX {\n', '    string public constant name = "LatiumX";\n', '    string public constant symbol = "LATX";\n', '    uint8 public constant decimals = 8;\n', '    uint256 public constant totalSupply =\n', '        300000000 * 10 ** uint256(decimals);\n', '\n', '    // owner of this contract\n', '    address public owner;\n', '\n', '    // balances for each account\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    // triggered when tokens are transferred\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '    // constructor\n', '    function LatiumX() {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;\n', '    }\n', '\n', '    // transfer the balance from sender&#39;s account to another one\n', '    function transfer(address _to, uint256 _value) {\n', '        // prevent transfer to 0x0 address\n', '        require(_to != 0x0);\n', '        // sender and recipient should be different\n', '        require(msg.sender != _to);\n', '        // check if the sender has enough coins\n', '        require(_value > 0 && balanceOf[msg.sender] >= _value);\n', '        // check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // subtract coins from sender&#39;s account\n', '        balanceOf[msg.sender] -= _value;\n', '        // add coins to recipient&#39;s account\n', '        balanceOf[_to] += _value;\n', '        // notify listeners about this transfer\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '}\n', '\n', 'contract LatiumLocker {\n', '    address private constant _latiumAddress = 0x2f85E502a988AF76f7ee6D83b7db8d6c0A823bf9;\n', '    LatiumX private constant _latium = LatiumX(_latiumAddress);\n', '\n', '    // total amount of Latium tokens that can be locked with this contract\n', '    uint256 private _lockLimit = 0;\n', '\n', '    // variables for release tiers and iteration thru them\n', '    uint32[] private _timestamps = [\n', '        1517400000 // 2018-01-31 12:00:00 UTC\n', '        , 1525089600 // 2018-04-30 12:00:00 UTC\n', '        , 1533038400 // 2018-07-31 12:00:00 UTC\n', '        , 1540987200 // 2018-10-31 12:00:00 UTC\n', '        \n', '    ];\n', '    uint32[] private _tokensToRelease = [ // without decimals\n', '        15000000\n', '        , 15000000\n', '        , 15000000\n', '        , 15000000\n', '       \n', '    ];\n', '    mapping (uint32 => uint256) private _releaseTiers;\n', '\n', '    // owner of this contract\n', '    address public owner;\n', '\n', '    // constructor\n', '    function LatiumLocker() {\n', '        owner = msg.sender;\n', '        // initialize release tiers with pairs:\n', '        // "UNIX timestamp" => "amount of tokens to release" (with decimals)\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            _releaseTiers[_timestamps[i]] =\n', '                _tokensToRelease[i] * 10 ** uint256(_latium.decimals());\n', '            _lockLimit += _releaseTiers[_timestamps[i]];\n', '        }\n', '    }\n', '\n', '    // function to get current Latium balance (with decimals)\n', '    // of this contract\n', '    function latiumBalance() constant returns (uint256 balance) {\n', '        return _latium.balanceOf(address(this));\n', '    }\n', '\n', '    // function to get total amount of Latium tokens (with decimals)\n', '    // that can be locked with this contract\n', '    function lockLimit() constant returns (uint256 limit) {\n', '        return _lockLimit;\n', '    }\n', '\n', '    // function to get amount of Latium tokens (with decimals)\n', '    // that are locked at this moment\n', '    function lockedTokens() constant returns (uint256 locked) {\n', '        locked = 0;\n', '        uint256 unlocked = 0;\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            if (now >= _timestamps[i]) {\n', '                unlocked += _releaseTiers[_timestamps[i]];\n', '            } else {\n', '                locked += _releaseTiers[_timestamps[i]];\n', '            }\n', '        }\n', '        uint256 balance = latiumBalance();\n', '        if (unlocked > balance) {\n', '            locked = 0;\n', '        } else {\n', '            balance -= unlocked;\n', '            if (balance < locked) {\n', '                locked = balance;\n', '            }\n', '        }\n', '    }\n', '\n', '    // function to get amount of Latium tokens (with decimals)\n', '    // that can be withdrawn at this moment\n', '    function canBeWithdrawn() constant returns (uint256 unlockedTokens, uint256 excessTokens) {\n', '        unlockedTokens = 0;\n', '        excessTokens = 0;\n', '        uint256 tiersBalance = 0;\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            tiersBalance += _releaseTiers[_timestamps[i]];\n', '            if (now >= _timestamps[i]) {\n', '                unlockedTokens += _releaseTiers[_timestamps[i]];\n', '            }\n', '        }\n', '        uint256 balance = latiumBalance();\n', '        if (unlockedTokens > balance) {\n', '            // actual Latium balance of this contract is smaller\n', '            // than can be released at this moment\n', '            unlockedTokens = balance;\n', '        } else if (balance > tiersBalance) {\n', '            // if actual Latium balance of this contract is greater\n', '            // than can be locked, all excess tokens can be withdrawn\n', '            // at any time\n', '            excessTokens = (balance - tiersBalance);\n', '        }\n', '    }\n', '\n', '    // functions with this modifier can only be executed by the owner\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // function to withdraw Latium tokens that are unlocked at this moment\n', '    function withdraw(uint256 _amount) onlyOwner {\n', '        var (unlockedTokens, excessTokens) = canBeWithdrawn();\n', '        uint256 totalAmount = unlockedTokens + excessTokens;\n', '        require(totalAmount > 0);\n', '        if (_amount == 0) {\n', '            // withdraw all available tokens\n', '            _amount = totalAmount;\n', '        }\n', '        require(totalAmount >= _amount);\n', '        uint256 unlockedToWithdraw =\n', '            _amount > unlockedTokens ?\n', '                unlockedTokens :\n', '                _amount;\n', '        if (unlockedToWithdraw > 0) {\n', '            // update tiers data\n', '            uint8 i = 0;\n', '            while (unlockedToWithdraw > 0 && i < _timestamps.length) {\n', '                if (now >= _timestamps[i]) {\n', '                    uint256 amountToReduce =\n', '                        unlockedToWithdraw > _releaseTiers[_timestamps[i]] ?\n', '                            _releaseTiers[_timestamps[i]] :\n', '                            unlockedToWithdraw;\n', '                    _releaseTiers[_timestamps[i]] -= amountToReduce;\n', '                    unlockedToWithdraw -= amountToReduce;\n', '                }\n', '                i++;\n', '            }\n', '        }\n', '        // transfer tokens to owner&#39;s account\n', '        _latium.transfer(msg.sender, _amount);\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract LatiumX {\n', '    string public constant name = "LatiumX";\n', '    string public constant symbol = "LATX";\n', '    uint8 public constant decimals = 8;\n', '    uint256 public constant totalSupply =\n', '        300000000 * 10 ** uint256(decimals);\n', '\n', '    // owner of this contract\n', '    address public owner;\n', '\n', '    // balances for each account\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    // triggered when tokens are transferred\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '    // constructor\n', '    function LatiumX() {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;\n', '    }\n', '\n', "    // transfer the balance from sender's account to another one\n", '    function transfer(address _to, uint256 _value) {\n', '        // prevent transfer to 0x0 address\n', '        require(_to != 0x0);\n', '        // sender and recipient should be different\n', '        require(msg.sender != _to);\n', '        // check if the sender has enough coins\n', '        require(_value > 0 && balanceOf[msg.sender] >= _value);\n', '        // check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', "        // subtract coins from sender's account\n", '        balanceOf[msg.sender] -= _value;\n', "        // add coins to recipient's account\n", '        balanceOf[_to] += _value;\n', '        // notify listeners about this transfer\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '}\n', '\n', 'contract LatiumLocker {\n', '    address private constant _latiumAddress = 0x2f85E502a988AF76f7ee6D83b7db8d6c0A823bf9;\n', '    LatiumX private constant _latium = LatiumX(_latiumAddress);\n', '\n', '    // total amount of Latium tokens that can be locked with this contract\n', '    uint256 private _lockLimit = 0;\n', '\n', '    // variables for release tiers and iteration thru them\n', '    uint32[] private _timestamps = [\n', '        1517400000 // 2018-01-31 12:00:00 UTC\n', '        , 1525089600 // 2018-04-30 12:00:00 UTC\n', '        , 1533038400 // 2018-07-31 12:00:00 UTC\n', '        , 1540987200 // 2018-10-31 12:00:00 UTC\n', '        \n', '    ];\n', '    uint32[] private _tokensToRelease = [ // without decimals\n', '        15000000\n', '        , 15000000\n', '        , 15000000\n', '        , 15000000\n', '       \n', '    ];\n', '    mapping (uint32 => uint256) private _releaseTiers;\n', '\n', '    // owner of this contract\n', '    address public owner;\n', '\n', '    // constructor\n', '    function LatiumLocker() {\n', '        owner = msg.sender;\n', '        // initialize release tiers with pairs:\n', '        // "UNIX timestamp" => "amount of tokens to release" (with decimals)\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            _releaseTiers[_timestamps[i]] =\n', '                _tokensToRelease[i] * 10 ** uint256(_latium.decimals());\n', '            _lockLimit += _releaseTiers[_timestamps[i]];\n', '        }\n', '    }\n', '\n', '    // function to get current Latium balance (with decimals)\n', '    // of this contract\n', '    function latiumBalance() constant returns (uint256 balance) {\n', '        return _latium.balanceOf(address(this));\n', '    }\n', '\n', '    // function to get total amount of Latium tokens (with decimals)\n', '    // that can be locked with this contract\n', '    function lockLimit() constant returns (uint256 limit) {\n', '        return _lockLimit;\n', '    }\n', '\n', '    // function to get amount of Latium tokens (with decimals)\n', '    // that are locked at this moment\n', '    function lockedTokens() constant returns (uint256 locked) {\n', '        locked = 0;\n', '        uint256 unlocked = 0;\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            if (now >= _timestamps[i]) {\n', '                unlocked += _releaseTiers[_timestamps[i]];\n', '            } else {\n', '                locked += _releaseTiers[_timestamps[i]];\n', '            }\n', '        }\n', '        uint256 balance = latiumBalance();\n', '        if (unlocked > balance) {\n', '            locked = 0;\n', '        } else {\n', '            balance -= unlocked;\n', '            if (balance < locked) {\n', '                locked = balance;\n', '            }\n', '        }\n', '    }\n', '\n', '    // function to get amount of Latium tokens (with decimals)\n', '    // that can be withdrawn at this moment\n', '    function canBeWithdrawn() constant returns (uint256 unlockedTokens, uint256 excessTokens) {\n', '        unlockedTokens = 0;\n', '        excessTokens = 0;\n', '        uint256 tiersBalance = 0;\n', '        for (uint8 i = 0; i < _timestamps.length; i++) {\n', '            tiersBalance += _releaseTiers[_timestamps[i]];\n', '            if (now >= _timestamps[i]) {\n', '                unlockedTokens += _releaseTiers[_timestamps[i]];\n', '            }\n', '        }\n', '        uint256 balance = latiumBalance();\n', '        if (unlockedTokens > balance) {\n', '            // actual Latium balance of this contract is smaller\n', '            // than can be released at this moment\n', '            unlockedTokens = balance;\n', '        } else if (balance > tiersBalance) {\n', '            // if actual Latium balance of this contract is greater\n', '            // than can be locked, all excess tokens can be withdrawn\n', '            // at any time\n', '            excessTokens = (balance - tiersBalance);\n', '        }\n', '    }\n', '\n', '    // functions with this modifier can only be executed by the owner\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // function to withdraw Latium tokens that are unlocked at this moment\n', '    function withdraw(uint256 _amount) onlyOwner {\n', '        var (unlockedTokens, excessTokens) = canBeWithdrawn();\n', '        uint256 totalAmount = unlockedTokens + excessTokens;\n', '        require(totalAmount > 0);\n', '        if (_amount == 0) {\n', '            // withdraw all available tokens\n', '            _amount = totalAmount;\n', '        }\n', '        require(totalAmount >= _amount);\n', '        uint256 unlockedToWithdraw =\n', '            _amount > unlockedTokens ?\n', '                unlockedTokens :\n', '                _amount;\n', '        if (unlockedToWithdraw > 0) {\n', '            // update tiers data\n', '            uint8 i = 0;\n', '            while (unlockedToWithdraw > 0 && i < _timestamps.length) {\n', '                if (now >= _timestamps[i]) {\n', '                    uint256 amountToReduce =\n', '                        unlockedToWithdraw > _releaseTiers[_timestamps[i]] ?\n', '                            _releaseTiers[_timestamps[i]] :\n', '                            unlockedToWithdraw;\n', '                    _releaseTiers[_timestamps[i]] -= amountToReduce;\n', '                    unlockedToWithdraw -= amountToReduce;\n', '                }\n', '                i++;\n', '            }\n', '        }\n', "        // transfer tokens to owner's account\n", '        _latium.transfer(msg.sender, _amount);\n', '    }\n', '}']
