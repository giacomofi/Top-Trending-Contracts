['pragma solidity ^0.4.21;\n', '\n', '// File: @gnosis.pm/util-contracts/contracts/Math.sol\n', '\n', '/// @title Math library - Allows calculation of logarithmic and exponential functions\n', '/// @author Alan Lu - <alan.lu@gnosis.pm>\n', '/// @author Stefan George - <stefan@gnosis.pm>\n', 'library Math {\n', '\n', '    /*\n', '     *  Constants\n', '     */\n', '    // This is equal to 1 in our calculations\n', '    uint public constant ONE =  0x10000000000000000;\n', '    uint public constant LN2 = 0xb17217f7d1cf79ac;\n', '    uint public constant LOG2_E = 0x171547652b82fe177;\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    /// @dev Returns natural exponential function value of given x\n', '    /// @param x x\n', '    /// @return e**x\n', '    function exp(int x)\n', '        public\n', '        pure\n', '        returns (uint)\n', '    {\n', '        // revert if x is > MAX_POWER, where\n', '        // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))\n', '        require(x <= 2454971259878909886679);\n', '        // return 0 if exp(x) is tiny, using\n', '        // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))\n', '        if (x < -818323753292969962227)\n', '            return 0;\n', '        // Transform so that e^x -> 2^x\n', '        x = x * int(ONE) / int(LN2);\n', '        // 2^x = 2^whole(x) * 2^frac(x)\n', '        //       ^^^^^^^^^^ is a bit shift\n', '        // so Taylor expand on z = frac(x)\n', '        int shift;\n', '        uint z;\n', '        if (x >= 0) {\n', '            shift = x / int(ONE);\n', '            z = uint(x % int(ONE));\n', '        }\n', '        else {\n', '            shift = x / int(ONE) - 1;\n', '            z = ONE - uint(-x % int(ONE));\n', '        }\n', '        // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...\n', '        //\n', '        // Can generate the z coefficients using mpmath and the following lines\n', '        // >>> from mpmath import mp\n', '        // >>> mp.dps = 100\n', '        // >>> ONE =  0x10000000000000000\n', '        // >>> print(&#39;\\n&#39;.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))\n', '        // 0xb17217f7d1cf79ab\n', '        // 0x3d7f7bff058b1d50\n', '        // 0xe35846b82505fc5\n', '        // 0x276556df749cee5\n', '        // 0x5761ff9e299cc4\n', '        // 0xa184897c363c3\n', '        uint zpow = z;\n', '        uint result = ONE;\n', '        result += 0xb17217f7d1cf79ab * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x3d7f7bff058b1d50 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0xe35846b82505fc5 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x276556df749cee5 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x5761ff9e299cc4 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0xa184897c363c3 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0xffe5fe2c4586 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x162c0223a5c8 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x1b5253d395e * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x1e4cf5158b * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x1e8cac735 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x1c3bd650 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x1816193 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x131496 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0xe1b7 * zpow / ONE;\n', '        zpow = zpow * z / ONE;\n', '        result += 0x9c7 * zpow / ONE;\n', '        if (shift >= 0) {\n', '            if (result >> (256-shift) > 0)\n', '                return (2**256-1);\n', '            return result << shift;\n', '        }\n', '        else\n', '            return result >> (-shift);\n', '    }\n', '\n', '    /// @dev Returns natural logarithm value of given x\n', '    /// @param x x\n', '    /// @return ln(x)\n', '    function ln(uint x)\n', '        public\n', '        pure\n', '        returns (int)\n', '    {\n', '        require(x > 0);\n', '        // binary search for floor(log2(x))\n', '        int ilog2 = floorLog2(x);\n', '        int z;\n', '        if (ilog2 < 0)\n', '            z = int(x << uint(-ilog2));\n', '        else\n', '            z = int(x >> uint(ilog2));\n', '        // z = x * 2^-⌊log₂x⌋\n', '        // so 1 <= z < 2\n', '        // and ln z = ln x - ⌊log₂x⌋/log₂e\n', '        // so just compute ln z using artanh series\n', '        // and calculate ln x from that\n', '        int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));\n', '        int halflnz = term;\n', '        int termpow = term * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 3;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 5;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 7;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 9;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 11;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 13;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 15;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 17;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 19;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 21;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 23;\n', '        termpow = termpow * term / int(ONE) * term / int(ONE);\n', '        halflnz += termpow / 25;\n', '        return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;\n', '    }\n', '\n', '    /// @dev Returns base 2 logarithm value of given x\n', '    /// @param x x\n', '    /// @return logarithmic value\n', '    function floorLog2(uint x)\n', '        public\n', '        pure\n', '        returns (int lo)\n', '    {\n', '        lo = -64;\n', '        int hi = 193;\n', '        // I use a shift here instead of / 2 because it floors instead of rounding towards 0\n', '        int mid = (hi + lo) >> 1;\n', '        while((lo + 1) < hi) {\n', '            if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)\n', '                hi = mid;\n', '            else\n', '                lo = mid;\n', '            mid = (hi + lo) >> 1;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns maximum of an array\n', '    /// @param nums Numbers to look through\n', '    /// @return Maximum number\n', '    function max(int[] nums)\n', '        public\n', '        pure\n', '        returns (int maxNum)\n', '    {\n', '        require(nums.length > 0);\n', '        maxNum = -2**255;\n', '        for (uint i = 0; i < nums.length; i++)\n', '            if (nums[i] > maxNum)\n', '                maxNum = nums[i];\n', '    }\n', '\n', '    /// @dev Returns whether an add operation causes an overflow\n', '    /// @param a First addend\n', '    /// @param b Second addend\n', '    /// @return Did no overflow occur?\n', '    function safeToAdd(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return a + b >= a;\n', '    }\n', '\n', '    /// @dev Returns whether a subtraction operation causes an underflow\n', '    /// @param a Minuend\n', '    /// @param b Subtrahend\n', '    /// @return Did no underflow occur?\n', '    function safeToSub(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return a >= b;\n', '    }\n', '\n', '    /// @dev Returns whether a multiply operation causes an overflow\n', '    /// @param a First factor\n', '    /// @param b Second factor\n', '    /// @return Did no overflow occur?\n', '    function safeToMul(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return b == 0 || a * b / b == a;\n', '    }\n', '\n', '    /// @dev Returns sum if no overflow occurred\n', '    /// @param a First addend\n', '    /// @param b Second addend\n', '    /// @return Sum\n', '    function add(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        require(safeToAdd(a, b));\n', '        return a + b;\n', '    }\n', '\n', '    /// @dev Returns difference if no overflow occurred\n', '    /// @param a Minuend\n', '    /// @param b Subtrahend\n', '    /// @return Difference\n', '    function sub(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        require(safeToSub(a, b));\n', '        return a - b;\n', '    }\n', '\n', '    /// @dev Returns product if no overflow occurred\n', '    /// @param a First factor\n', '    /// @param b Second factor\n', '    /// @return Product\n', '    function mul(uint a, uint b)\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        require(safeToMul(a, b));\n', '        return a * b;\n', '    }\n', '\n', '    /// @dev Returns whether an add operation causes an overflow\n', '    /// @param a First addend\n', '    /// @param b Second addend\n', '    /// @return Did no overflow occur?\n', '    function safeToAdd(int a, int b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);\n', '    }\n', '\n', '    /// @dev Returns whether a subtraction operation causes an underflow\n', '    /// @param a Minuend\n', '    /// @param b Subtrahend\n', '    /// @return Did no underflow occur?\n', '    function safeToSub(int a, int b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);\n', '    }\n', '\n', '    /// @dev Returns whether a multiply operation causes an overflow\n', '    /// @param a First factor\n', '    /// @param b Second factor\n', '    /// @return Did no overflow occur?\n', '    function safeToMul(int a, int b)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return (b == 0) || (a * b / b == a);\n', '    }\n', '\n', '    /// @dev Returns sum if no overflow occurred\n', '    /// @param a First addend\n', '    /// @param b Second addend\n', '    /// @return Sum\n', '    function add(int a, int b)\n', '        internal\n', '        pure\n', '        returns (int)\n', '    {\n', '        require(safeToAdd(a, b));\n', '        return a + b;\n', '    }\n', '\n', '    /// @dev Returns difference if no overflow occurred\n', '    /// @param a Minuend\n', '    /// @param b Subtrahend\n', '    /// @return Difference\n', '    function sub(int a, int b)\n', '        internal\n', '        pure\n', '        returns (int)\n', '    {\n', '        require(safeToSub(a, b));\n', '        return a - b;\n', '    }\n', '\n', '    /// @dev Returns product if no overflow occurred\n', '    /// @param a First factor\n', '    /// @param b Second factor\n', '    /// @return Product\n', '    function mul(int a, int b)\n', '        internal\n', '        pure\n', '        returns (int)\n', '    {\n', '        require(safeToMul(a, b));\n', '        return a * b;\n', '    }\n', '}\n', '\n', '// File: @gnosis.pm/util-contracts/contracts/Proxy.sol\n', '\n', '/// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.\n', '/// @author Alan Lu - <alan@gnosis.pm>\n', 'contract Proxied {\n', '    address public masterCopy;\n', '}\n', '\n', '/// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.\n', '/// @author Stefan George - <stefan@gnosis.pm>\n', 'contract Proxy is Proxied {\n', '    /// @dev Constructor function sets address of master copy contract.\n', '    /// @param _masterCopy Master copy address.\n', '    function Proxy(address _masterCopy)\n', '        public\n', '    {\n', '        require(_masterCopy != 0);\n', '        masterCopy = _masterCopy;\n', '    }\n', '\n', '    /// @dev Fallback function forwards all transactions and returns all received return data.\n', '    function ()\n', '        external\n', '        payable\n', '    {\n', '        address _masterCopy = masterCopy;\n', '        assembly {\n', '            calldatacopy(0, 0, calldatasize())\n', '            let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)\n', '            returndatacopy(0, 0, returndatasize())\n', '            switch success\n', '            case 0 { revert(0, returndatasize()) }\n', '            default { return(0, returndatasize()) }\n', '        }\n', '    }\n', '}\n', '\n', '// File: @gnosis.pm/util-contracts/contracts/Token.sol\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', 'pragma solidity ^0.4.21;\n', '\n', '\n', '/// @title Abstract token contract - Functions to be implemented by token contracts\n', 'contract Token {\n', '\n', '    /*\n', '     *  Events\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    function transfer(address to, uint value) public returns (bool);\n', '    function transferFrom(address from, address to, uint value) public returns (bool);\n', '    function approve(address spender, uint value) public returns (bool);\n', '    function balanceOf(address owner) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '    function totalSupply() public view returns (uint);\n', '}\n', '\n', '// File: @gnosis.pm/util-contracts/contracts/StandardToken.sol\n', '\n', 'contract StandardTokenData {\n', '\n', '    /*\n', '     *  Storage\n', '     */\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowances;\n', '    uint totalTokens;\n', '}\n', '\n', '/// @title Standard token contract with overflow protection\n', 'contract StandardToken is Token, StandardTokenData {\n', '    using Math for *;\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    /// @dev Transfers sender&#39;s tokens to a given address. Returns success\n', '    /// @param to Address of token receiver\n', '    /// @param value Number of tokens to transfer\n', '    /// @return Was transfer successful?\n', '    function transfer(address to, uint value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (   !balances[msg.sender].safeToSub(value)\n', '            || !balances[to].safeToAdd(value))\n', '            return false;\n', '        balances[msg.sender] -= value;\n', '        balances[to] += value;\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success\n', '    /// @param from Address from where tokens are withdrawn\n', '    /// @param to Address to where tokens are sent\n', '    /// @param value Number of tokens to transfer\n', '    /// @return Was transfer successful?\n', '    function transferFrom(address from, address to, uint value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (   !balances[from].safeToSub(value)\n', '            || !allowances[from][msg.sender].safeToSub(value)\n', '            || !balances[to].safeToAdd(value))\n', '            return false;\n', '        balances[from] -= value;\n', '        allowances[from][msg.sender] -= value;\n', '        balances[to] += value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success\n', '    /// @param spender Address of allowed account\n', '    /// @param value Number of approved tokens\n', '    /// @return Was approval successful?\n', '    function approve(address spender, uint value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowances[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Returns number of allowed tokens for given address\n', '    /// @param owner Address of token owner\n', '    /// @param spender Address of token spender\n', '    /// @return Remaining allowance for spender\n', '    function allowance(address owner, address spender)\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        return allowances[owner][spender];\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address\n', '    /// @param owner Address of token owner\n', '    /// @return Balance of owner\n', '    function balanceOf(address owner)\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        return balances[owner];\n', '    }\n', '\n', '    /// @dev Returns total supply of tokens\n', '    /// @return Total supply\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        return totalTokens;\n', '    }\n', '}\n', '\n', '// File: contracts/TokenOWL.sol\n', '\n', 'contract TokenOWL is Proxied, StandardToken {\n', '    using Math for *;\n', '\n', '    string public constant name = "OWL Token";\n', '    string public constant symbol = "OWL";\n', '    uint8 public constant decimals = 18;\n', '\n', '    struct masterCopyCountdownType {\n', '        address masterCopy;\n', '        uint timeWhenAvailable;\n', '    }\n', '\n', '    masterCopyCountdownType masterCopyCountdown;\n', '\n', '    address public creator;\n', '    address public minter;\n', '\n', '    event Minted(address indexed to, uint256 amount);\n', '    event Burnt(address indexed from, address indexed user, uint256 amount);\n', '\n', '    modifier onlyCreator() {\n', '        // R1\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '    /// @dev trickers the update process via the proxyMaster for a new address _masterCopy \n', '    /// updating is only possible after 30 days\n', '    function startMasterCopyCountdown (\n', '        address _masterCopy\n', '     )\n', '        public\n', '        onlyCreator()\n', '    {\n', '        require(address(_masterCopy) != 0);\n', '\n', '        // Update masterCopyCountdown\n', '        masterCopyCountdown.masterCopy = _masterCopy;\n', '        masterCopyCountdown.timeWhenAvailable = now + 30 days;\n', '    }\n', '\n', '     /// @dev executes the update process via the proxyMaster for a new address _masterCopy\n', '    function updateMasterCopy()\n', '        public\n', '        onlyCreator()\n', '    {   \n', '        require(address(masterCopyCountdown.masterCopy) != 0);\n', '        require(now >= masterCopyCountdown.timeWhenAvailable);\n', '\n', '        // Update masterCopy\n', '        masterCopy = masterCopyCountdown.masterCopy;\n', '    }\n', '\n', '    function getMasterCopy()\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return masterCopy;\n', '    }\n', '\n', '    /// @dev Set minter. Only the creator of this contract can call this.\n', '    /// @param newMinter The new address authorized to mint this token\n', '    function setMinter(address newMinter)\n', '        public\n', '        onlyCreator()\n', '    {\n', '        minter = newMinter;\n', '    }\n', '\n', '\n', '    /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.\n', '    /// @param newOwner The new address, which should become the owner\n', '    function setNewOwner(address newOwner)\n', '        public\n', '        onlyCreator()\n', '    {\n', '        creator = newOwner;\n', '    }\n', '\n', '    /// @dev Mints OWL.\n', '    /// @param to Address to which the minted token will be given\n', '    /// @param amount Amount of OWL to be minted\n', '    function mintOWL(address to, uint amount)\n', '        public\n', '    {\n', '        require(minter != 0 && msg.sender == minter);\n', '        balances[to] = balances[to].add(amount);\n', '        totalTokens = totalTokens.add(amount);\n', '        emit Minted(to, amount);\n', '    }\n', '\n', '    /// @dev Burns OWL.\n', '    /// @param user Address of OWL owner\n', '    /// @param amount Amount of OWL to be burnt\n', '    function burnOWL(address user, uint amount)\n', '        public\n', '    {\n', '        allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);\n', '        balances[user] = balances[user].sub(amount);\n', '        totalTokens = totalTokens.sub(amount);\n', '        emit Burnt(msg.sender, user, amount);\n', '    }\n', '}']