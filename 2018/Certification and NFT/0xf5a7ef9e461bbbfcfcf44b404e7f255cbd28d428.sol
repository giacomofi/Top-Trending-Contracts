['// File: contracts-raw/CryptoSpin.sol\n', '\n', '//   ____                  _          ____        _\n', '//  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __\n', '// | |   | &#39;__| | | | &#39;_ \\| __/ _ \\  \\___ \\| &#39;_ \\| | &#39;_ \\\n', '// | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |\n', '//  \\____|_|   \\__, | .__/ \\__\\___/  |____/| .__/|_|_| |_|\n', '//             |___/|_|                    |_|\n', '\n', '// Crypto Spin - Ethereum Slot Machine with Uncompromised RTP\n', '// Copyright 2018 www.cryptospin.co\n', '// In association with www.budapestgame.com\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// File: contracts-raw/Ownable.sol\n', '\n', 'contract Ownable {\n', '        address public        owner;\n', '\n', '        event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);\n', '\n', '        constructor () public {\n', '                owner       = msg.sender;\n', '        }\n', '\n', '        modifier onlyOwner () {\n', '                require (msg.sender == owner);\n', '                _;\n', '        }\n', '\n', '        function transferOwnership (address newOwner) public onlyOwner {\n', '              require (newOwner != address (0));\n', '\n', '              emit OwnershipTransferred (owner, newOwner);\n', '              owner     = newOwner;\n', '        }\n', '}\n', '\n', '// File: contracts-raw/Pausable.sol\n', '\n', 'contract Pausable is Ownable {\n', '        event Pause ();\n', '        event Unpause ();\n', '\n', '        bool public paused        = false;\n', '\n', '        modifier whenNotPaused () {\n', '                require(!paused);\n', '                _;\n', '        }\n', '\n', '        modifier whenPaused () {\n', '                require (paused);\n', '                _;\n', '        }\n', '\n', '        function pause () onlyOwner whenNotPaused public {\n', '                paused  = true;\n', '                emit Pause ();\n', '        }\n', '\n', '        function unpause () onlyOwner whenPaused public {\n', '                paused = false;\n', '                emit Unpause ();\n', '        }\n', '}\n', '\n', '// File: contracts-raw/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '        function add (uint256 a, uint256 b) internal pure returns (uint256) {\n', '              uint256   c = a + b;\n', '              assert (c >= a);\n', '              return c;\n', '        }\n', '\n', '        function sub (uint256 a, uint256 b) internal pure returns (uint256) {\n', '              assert (b <= a);\n', '              return a - b;\n', '        }\n', '\n', '        function mul (uint256 a, uint256 b) internal pure returns (uint256) {\n', '                if (a == 0) {\n', '                        return 0;\n', '                }\n', '                uint256 c = a * b;\n', '                assert (c/a == b);\n', '                return c;\n', '        }\n', '\n', '        // Solidty automatically throws\n', '        // function div (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        //       // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        //       uint256   c = a/b;\n', '        //       // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        //       return c;\n', '        // }\n', '}\n', '\n', '// File: contracts-raw/CryptoSpin.sol\n', '\n', '//   ____                  _          ____        _\n', '//  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __\n', '// | |   | &#39;__| | | | &#39;_ \\| __/ _ \\  \\___ \\| &#39;_ \\| | &#39;_ \\\n', '// | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |\n', '//  \\____|_|   \\__, | .__/ \\__\\___/  |____/| .__/|_|_| |_|\n', '//             |___/|_|                    |_|\n', '\n', '// Crypto Spin - Ethereum Slot Machine with Uncompromised RTP\n', '// Copyright 2018 www.cryptospin.co\n', '// In association with www.budapestgame.com\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', 'contract RSPTokenInterface {\n', '        function version () public pure returns (uint8);\n', '\n', '        function buyTokens (address referral) public payable;\n', '        function sellTokens (uint256 amount) public;\n', '\n', '        function transfer (address to, uint256 amount) public returns (bool);\n', '\n', '        // function approve (address spender, uint256 amount) public returns (bool);\n', '        // function transferFrom (address from, address to, uint256 amount) public returns (bool);\n', '}\n', '\n', '\n', 'contract CryptoSpin is Pausable {\n', '        using SafeMath for uint256;\n', '\n', '        uint8 public    version             = 2;\n', '\n', '        RSPTokenInterface public        rspToken;\n', '\n', '        function _setRspTokenAddress (address addr) internal {\n', '                RSPTokenInterface     candidate     = RSPTokenInterface (addr);\n', '                require (candidate.version () >= 7);\n', '                rspToken        = candidate;\n', '        }\n', '\n', '        function setRspTokenAddress (address addr) public onlyOwner {\n', '                _setRspTokenAddress (addr);\n', '        }\n', '\n', '        // Constructor is not called multiple times, fortunately\n', '        // function CryptoSpin (address addr) public {\n', '        constructor (address addr) public {\n', '                // Onwer should be set up and become msg.sender\n', '                // During test, mint owner some amount\n', '                // During deployment, onwer himself has to buy tokens to be fair\n', '                // _mint (msg.sender, initialAmount);\n', '\n', '                if (addr != address(0)) {\n', '                        _setRspTokenAddress (addr);\n', '                }\n', '        }\n', '\n', '        event SlotToppedUp (address indexed gamer, uint256 nTokens);\n', '        event SlotToppedDown (address indexed gamer, uint256 nTokens);\n', '\n', '        // mapping (address => uint256) public         weisPaid;\n', '        mapping (address => uint256) public         nTokensCredited;\n', '        mapping (address => uint256) public         nTokensWithdrawn;\n', '\n', '        // Convenience\n', '        function playerInfo (address player) public view returns (uint256, uint256) {\n', '\n', '                return (\n', '                    nTokensCredited[player],\n', '                    nTokensWithdrawn[player]\n', '                );\n', '        }\n', '\n', '        // Escrew and start game\n', '        function _markCredit (address player, uint256 nTokens) internal {\n', '                // Overflow check (unnecessarily)\n', '                nTokensCredited[player]     = nTokensCredited[player].add (nTokens);\n', '                emit SlotToppedUp (player, nTokens);\n', '        }\n', '\n', '        function _markWithdraw (address player, uint256 nTokens) internal {\n', '                // Overflow check (unnecessarily)\n', '                nTokensWithdrawn[player]    = nTokensWithdrawn[player].add (nTokens);\n', '                emit SlotToppedDown (player, nTokens);\n', '        }\n', '\n', '        function buyAndTopup (address referral) whenNotPaused public payable {\n', '                // The contract holds the token until refunding\n', '                rspToken.buyTokens.value (msg.value) (referral);\n', '                uint256     nTokens     = msg.value.mul (8000);\n', '\n', '                _markCredit (msg.sender, nTokens);\n', '        }\n', '\n', '        function topdownAndCashout (address player, uint256 nTokens) onlyOwner public {\n', '                uint256     nWeis       = nTokens/8000;\n', '                uint256     nRspTokens  = nWeis.mul (5000);\n', '\n', '                rspToken.sellTokens (nRspTokens);\n', '\n', '                _markWithdraw (player, nTokens);\n', '                player.transfer (nWeis);\n', '        }\n', '\n', '        // EndGame\n', '        // function transferTokensTo (address to, uint256 nTokens) onlyOwner public {\n', '        //         rspToken.transfer (to, nTokens);\n', '        // }\n', '\n', '        function markCredit (address player, uint256 nTokens) onlyOwner public {\n', '                _markCredit (player, nTokens);\n', '        }\n', '\n', '        function () public payable {}\n', '\n', '\n', '}']
['// File: contracts-raw/CryptoSpin.sol\n', '\n', '//   ____                  _          ____        _\n', '//  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __\n', "// | |   | '__| | | | '_ \\| __/ _ \\  \\___ \\| '_ \\| | '_ \\\n", '// | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |\n', '//  \\____|_|   \\__, | .__/ \\__\\___/  |____/| .__/|_|_| |_|\n', '//             |___/|_|                    |_|\n', '\n', '// Crypto Spin - Ethereum Slot Machine with Uncompromised RTP\n', '// Copyright 2018 www.cryptospin.co\n', '// In association with www.budapestgame.com\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// File: contracts-raw/Ownable.sol\n', '\n', 'contract Ownable {\n', '        address public        owner;\n', '\n', '        event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);\n', '\n', '        constructor () public {\n', '                owner       = msg.sender;\n', '        }\n', '\n', '        modifier onlyOwner () {\n', '                require (msg.sender == owner);\n', '                _;\n', '        }\n', '\n', '        function transferOwnership (address newOwner) public onlyOwner {\n', '              require (newOwner != address (0));\n', '\n', '              emit OwnershipTransferred (owner, newOwner);\n', '              owner     = newOwner;\n', '        }\n', '}\n', '\n', '// File: contracts-raw/Pausable.sol\n', '\n', 'contract Pausable is Ownable {\n', '        event Pause ();\n', '        event Unpause ();\n', '\n', '        bool public paused        = false;\n', '\n', '        modifier whenNotPaused () {\n', '                require(!paused);\n', '                _;\n', '        }\n', '\n', '        modifier whenPaused () {\n', '                require (paused);\n', '                _;\n', '        }\n', '\n', '        function pause () onlyOwner whenNotPaused public {\n', '                paused  = true;\n', '                emit Pause ();\n', '        }\n', '\n', '        function unpause () onlyOwner whenPaused public {\n', '                paused = false;\n', '                emit Unpause ();\n', '        }\n', '}\n', '\n', '// File: contracts-raw/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '        function add (uint256 a, uint256 b) internal pure returns (uint256) {\n', '              uint256   c = a + b;\n', '              assert (c >= a);\n', '              return c;\n', '        }\n', '\n', '        function sub (uint256 a, uint256 b) internal pure returns (uint256) {\n', '              assert (b <= a);\n', '              return a - b;\n', '        }\n', '\n', '        function mul (uint256 a, uint256 b) internal pure returns (uint256) {\n', '                if (a == 0) {\n', '                        return 0;\n', '                }\n', '                uint256 c = a * b;\n', '                assert (c/a == b);\n', '                return c;\n', '        }\n', '\n', '        // Solidty automatically throws\n', '        // function div (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        //       // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        //       uint256   c = a/b;\n', "        //       // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        //       return c;\n', '        // }\n', '}\n', '\n', '// File: contracts-raw/CryptoSpin.sol\n', '\n', '//   ____                  _          ____        _\n', '//  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __\n', "// | |   | '__| | | | '_ \\| __/ _ \\  \\___ \\| '_ \\| | '_ \\\n", '// | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |\n', '//  \\____|_|   \\__, | .__/ \\__\\___/  |____/| .__/|_|_| |_|\n', '//             |___/|_|                    |_|\n', '\n', '// Crypto Spin - Ethereum Slot Machine with Uncompromised RTP\n', '// Copyright 2018 www.cryptospin.co\n', '// In association with www.budapestgame.com\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', 'contract RSPTokenInterface {\n', '        function version () public pure returns (uint8);\n', '\n', '        function buyTokens (address referral) public payable;\n', '        function sellTokens (uint256 amount) public;\n', '\n', '        function transfer (address to, uint256 amount) public returns (bool);\n', '\n', '        // function approve (address spender, uint256 amount) public returns (bool);\n', '        // function transferFrom (address from, address to, uint256 amount) public returns (bool);\n', '}\n', '\n', '\n', 'contract CryptoSpin is Pausable {\n', '        using SafeMath for uint256;\n', '\n', '        uint8 public    version             = 2;\n', '\n', '        RSPTokenInterface public        rspToken;\n', '\n', '        function _setRspTokenAddress (address addr) internal {\n', '                RSPTokenInterface     candidate     = RSPTokenInterface (addr);\n', '                require (candidate.version () >= 7);\n', '                rspToken        = candidate;\n', '        }\n', '\n', '        function setRspTokenAddress (address addr) public onlyOwner {\n', '                _setRspTokenAddress (addr);\n', '        }\n', '\n', '        // Constructor is not called multiple times, fortunately\n', '        // function CryptoSpin (address addr) public {\n', '        constructor (address addr) public {\n', '                // Onwer should be set up and become msg.sender\n', '                // During test, mint owner some amount\n', '                // During deployment, onwer himself has to buy tokens to be fair\n', '                // _mint (msg.sender, initialAmount);\n', '\n', '                if (addr != address(0)) {\n', '                        _setRspTokenAddress (addr);\n', '                }\n', '        }\n', '\n', '        event SlotToppedUp (address indexed gamer, uint256 nTokens);\n', '        event SlotToppedDown (address indexed gamer, uint256 nTokens);\n', '\n', '        // mapping (address => uint256) public         weisPaid;\n', '        mapping (address => uint256) public         nTokensCredited;\n', '        mapping (address => uint256) public         nTokensWithdrawn;\n', '\n', '        // Convenience\n', '        function playerInfo (address player) public view returns (uint256, uint256) {\n', '\n', '                return (\n', '                    nTokensCredited[player],\n', '                    nTokensWithdrawn[player]\n', '                );\n', '        }\n', '\n', '        // Escrew and start game\n', '        function _markCredit (address player, uint256 nTokens) internal {\n', '                // Overflow check (unnecessarily)\n', '                nTokensCredited[player]     = nTokensCredited[player].add (nTokens);\n', '                emit SlotToppedUp (player, nTokens);\n', '        }\n', '\n', '        function _markWithdraw (address player, uint256 nTokens) internal {\n', '                // Overflow check (unnecessarily)\n', '                nTokensWithdrawn[player]    = nTokensWithdrawn[player].add (nTokens);\n', '                emit SlotToppedDown (player, nTokens);\n', '        }\n', '\n', '        function buyAndTopup (address referral) whenNotPaused public payable {\n', '                // The contract holds the token until refunding\n', '                rspToken.buyTokens.value (msg.value) (referral);\n', '                uint256     nTokens     = msg.value.mul (8000);\n', '\n', '                _markCredit (msg.sender, nTokens);\n', '        }\n', '\n', '        function topdownAndCashout (address player, uint256 nTokens) onlyOwner public {\n', '                uint256     nWeis       = nTokens/8000;\n', '                uint256     nRspTokens  = nWeis.mul (5000);\n', '\n', '                rspToken.sellTokens (nRspTokens);\n', '\n', '                _markWithdraw (player, nTokens);\n', '                player.transfer (nWeis);\n', '        }\n', '\n', '        // EndGame\n', '        // function transferTokensTo (address to, uint256 nTokens) onlyOwner public {\n', '        //         rspToken.transfer (to, nTokens);\n', '        // }\n', '\n', '        function markCredit (address player, uint256 nTokens) onlyOwner public {\n', '                _markCredit (player, nTokens);\n', '        }\n', '\n', '        function () public payable {}\n', '\n', '\n', '}']
