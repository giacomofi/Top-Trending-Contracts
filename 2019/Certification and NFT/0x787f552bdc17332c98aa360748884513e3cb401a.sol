['/*\n', '\n', '    Copyright 2019 dYdX Trading Inc.\n', '\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '\n', '*/\n', '\n', 'pragma solidity 0.5.7;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/protocol/interfaces/IErc20.sol\n', '\n', '/**\n', ' * @title IErc20\n', ' * @author dYdX\n', ' *\n', ' * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so\n', " * that we don't automatically revert when calling non-compliant tokens that have no return value for\n", ' * transfer(), transferFrom(), or approve().\n', ' */\n', 'interface IErc20 {\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    function totalSupply(\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function balanceOf(\n', '        address who\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function transfer(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '    function approve(\n', '        address spender,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '    function name()\n', '        external\n', '        view\n', '        returns (string memory);\n', '\n', '    function symbol()\n', '        external\n', '        view\n', '        returns (string memory);\n', '\n', '    function decimals()\n', '        external\n', '        view\n', '        returns (uint8);\n', '}\n', '\n', '// File: contracts/protocol/lib/Monetary.sol\n', '\n', '/**\n', ' * @title Monetary\n', ' * @author dYdX\n', ' *\n', ' * Library for types involving money\n', ' */\n', 'library Monetary {\n', '\n', '    /*\n', '     * The price of a base-unit of an asset.\n', '     */\n', '    struct Price {\n', '        uint256 value;\n', '    }\n', '\n', '    /*\n', '     * Total value of an some amount of an asset. Equal to (price * amount).\n', '     */\n', '    struct Value {\n', '        uint256 value;\n', '    }\n', '}\n', '\n', '// File: contracts/protocol/interfaces/IPriceOracle.sol\n', '\n', '/**\n', ' * @title IPriceOracle\n', ' * @author dYdX\n', ' *\n', ' * Interface that Price Oracles for Solo must implement in order to report prices.\n', ' */\n', 'contract IPriceOracle {\n', '\n', '    // ============ Constants ============\n', '\n', '    uint256 public constant ONE_DOLLAR = 10 ** 36;\n', '\n', '    // ============ Public Functions ============\n', '\n', '    /**\n', '     * Get the price of a token\n', '     *\n', '     * @param  token  The ERC20 token address of the market\n', '     * @return        The USD price of a base unit of the token, then multiplied by 10^36.\n', '     *                So a USD-stable coin with 18 decimal places would return 10^18.\n', '     *                This is the price of the base unit rather than the price of a "human-readable"\n', '     *                token amount. Every ERC20 may have a different number of decimals.\n', '     */\n', '    function getPrice(\n', '        address token\n', '    )\n', '        public\n', '        view\n', '        returns (Monetary.Price memory);\n', '}\n', '\n', '// File: contracts/protocol/lib/Require.sol\n', '\n', '/**\n', ' * @title Require\n', ' * @author dYdX\n', ' *\n', ' * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()\n', ' */\n', 'library Require {\n', '\n', '    // ============ Constants ============\n', '\n', "    uint256 constant ASCII_ZERO = 48; // '0'\n", "    uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10\n", "    uint256 constant ASCII_LOWER_EX = 120; // 'x'\n", "    bytes2 constant COLON = 0x3a20; // ': '\n", "    bytes2 constant COMMA = 0x2c20; // ', '\n", "    bytes2 constant LPAREN = 0x203c; // ' <'\n", "    byte constant RPAREN = 0x3e; // '>'\n", '    uint256 constant FOUR_BIT_MASK = 0xf;\n', '\n', '    // ============ Library Functions ============\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason)\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason,\n', '        uint256 payloadA\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason),\n', '                        LPAREN,\n', '                        stringify(payloadA),\n', '                        RPAREN\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason,\n', '        uint256 payloadA,\n', '        uint256 payloadB\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason),\n', '                        LPAREN,\n', '                        stringify(payloadA),\n', '                        COMMA,\n', '                        stringify(payloadB),\n', '                        RPAREN\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason,\n', '        address payloadA\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason),\n', '                        LPAREN,\n', '                        stringify(payloadA),\n', '                        RPAREN\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason,\n', '        address payloadA,\n', '        uint256 payloadB\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason),\n', '                        LPAREN,\n', '                        stringify(payloadA),\n', '                        COMMA,\n', '                        stringify(payloadB),\n', '                        RPAREN\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    function that(\n', '        bool must,\n', '        bytes32 file,\n', '        bytes32 reason,\n', '        address payloadA,\n', '        uint256 payloadB,\n', '        uint256 payloadC\n', '    )\n', '        internal\n', '        pure\n', '    {\n', '        if (!must) {\n', '            revert(\n', '                string(\n', '                    abi.encodePacked(\n', '                        stringify(file),\n', '                        COLON,\n', '                        stringify(reason),\n', '                        LPAREN,\n', '                        stringify(payloadA),\n', '                        COMMA,\n', '                        stringify(payloadB),\n', '                        COMMA,\n', '                        stringify(payloadC),\n', '                        RPAREN\n', '                    )\n', '                )\n', '            );\n', '        }\n', '    }\n', '\n', '    // ============ Private Functions ============\n', '\n', '    function stringify(\n', '        bytes32 input\n', '    )\n', '        private\n', '        pure\n', '        returns (bytes memory)\n', '    {\n', '        // put the input bytes into the result\n', '        bytes memory result = abi.encodePacked(input);\n', '\n', '        // determine the length of the input by finding the location of the last non-zero byte\n', '        for (uint256 i = 32; i > 0; ) {\n', '            // reverse-for-loops with unsigned integer\n', '            /* solium-disable-next-line security/no-modify-for-iter-var */\n', '            i--;\n', '\n', '            // find the last non-zero byte in order to determine the length\n', '            if (result[i] != 0) {\n', '                uint256 length = i + 1;\n', '\n', '                /* solium-disable-next-line security/no-inline-assembly */\n', '                assembly {\n', '                    mstore(result, length) // r.length = length;\n', '                }\n', '\n', '                return result;\n', '            }\n', '        }\n', '\n', '        // all bytes are zero\n', '        return new bytes(0);\n', '    }\n', '\n', '    function stringify(\n', '        uint256 input\n', '    )\n', '        private\n', '        pure\n', '        returns (bytes memory)\n', '    {\n', '        if (input == 0) {\n', '            return "0";\n', '        }\n', '\n', '        // get the final string length\n', '        uint256 j = input;\n', '        uint256 length;\n', '        while (j != 0) {\n', '            length++;\n', '            j /= 10;\n', '        }\n', '\n', '        // allocate the string\n', '        bytes memory bstr = new bytes(length);\n', '\n', '        // populate the string starting with the least-significant character\n', '        j = input;\n', '        for (uint256 i = length; i > 0; ) {\n', '            // reverse-for-loops with unsigned integer\n', '            /* solium-disable-next-line security/no-modify-for-iter-var */\n', '            i--;\n', '\n', '            // take last decimal digit\n', '            bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));\n', '\n', '            // remove the last decimal digit\n', '            j /= 10;\n', '        }\n', '\n', '        return bstr;\n', '    }\n', '\n', '    function stringify(\n', '        address input\n', '    )\n', '        private\n', '        pure\n', '        returns (bytes memory)\n', '    {\n', '        uint256 z = uint256(input);\n', '\n', '        // addresses are "0x" followed by 20 bytes of data which take up 2 characters each\n', '        bytes memory result = new bytes(42);\n', '\n', '        // populate the result with "0x"\n', '        result[0] = byte(uint8(ASCII_ZERO));\n', '        result[1] = byte(uint8(ASCII_LOWER_EX));\n', '\n', '        // for each byte (starting from the lowest byte), populate the result with two characters\n', '        for (uint256 i = 0; i < 20; i++) {\n', '            // each byte takes two characters\n', '            uint256 shift = i * 2;\n', '\n', '            // populate the least-significant character\n', '            result[41 - shift] = char(z & FOUR_BIT_MASK);\n', '            z = z >> 4;\n', '\n', '            // populate the most-significant character\n', '            result[40 - shift] = char(z & FOUR_BIT_MASK);\n', '            z = z >> 4;\n', '        }\n', '\n', '        return result;\n', '    }\n', '\n', '    function char(\n', '        uint256 input\n', '    )\n', '        private\n', '        pure\n', '        returns (byte)\n', '    {\n', '        // return ASCII digit (0-9)\n', '        if (input < 10) {\n', '            return byte(uint8(input + ASCII_ZERO));\n', '        }\n', '\n', '        // return ASCII letter (a-f)\n', '        return byte(uint8(input + ASCII_RELATIVE_ZERO));\n', '    }\n', '}\n', '\n', '// File: contracts/protocol/lib/Math.sol\n', '\n', '/**\n', ' * @title Math\n', ' * @author dYdX\n', ' *\n', ' * Library for non-standard Math functions\n', ' */\n', 'library Math {\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Constants ============\n', '\n', '    bytes32 constant FILE = "Math";\n', '\n', '    // ============ Library Functions ============\n', '\n', '    /*\n', '     * Return target * (numerator / denominator).\n', '     */\n', '    function getPartial(\n', '        uint256 target,\n', '        uint256 numerator,\n', '        uint256 denominator\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return target.mul(numerator).div(denominator);\n', '    }\n', '\n', '    /*\n', '     * Return target * (numerator / denominator), but rounded up.\n', '     */\n', '    function getPartialRoundUp(\n', '        uint256 target,\n', '        uint256 numerator,\n', '        uint256 denominator\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        if (target == 0 || numerator == 0) {\n', '            // SafeMath will check for zero denominator\n', '            return SafeMath.div(0, denominator);\n', '        }\n', '        return target.mul(numerator).sub(1).div(denominator).add(1);\n', '    }\n', '\n', '    function to128(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint128)\n', '    {\n', '        uint128 result = uint128(number);\n', '        Require.that(\n', '            result == number,\n', '            FILE,\n', '            "Unsafe cast to uint128"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function to96(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint96)\n', '    {\n', '        uint96 result = uint96(number);\n', '        Require.that(\n', '            result == number,\n', '            FILE,\n', '            "Unsafe cast to uint96"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function to32(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint32)\n', '    {\n', '        uint32 result = uint32(number);\n', '        Require.that(\n', '            result == number,\n', '            FILE,\n', '            "Unsafe cast to uint32"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function min(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a > b ? a : b;\n', '    }\n', '}\n', '\n', '// File: contracts/protocol/lib/Time.sol\n', '\n', '/**\n', ' * @title Time\n', ' * @author dYdX\n', ' *\n', ' * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)\n', ' */\n', 'library Time {\n', '\n', '    // ============ Library Functions ============\n', '\n', '    function currentTime()\n', '        internal\n', '        view\n', '        returns (uint32)\n', '    {\n', '        return Math.to32(block.timestamp);\n', '    }\n', '}\n', '\n', '// File: contracts/external/interfaces/IMakerOracle.sol\n', '\n', '/**\n', ' * @title IMakerOracle\n', ' * @author dYdX\n', ' *\n', ' * Interface for the price oracles run by MakerDao\n', ' */\n', 'interface IMakerOracle {\n', '\n', '    // Event that is logged when the `note` modifier is used\n', '    event LogNote(\n', '        bytes4 indexed msgSig,\n', '        address indexed msgSender,\n', '        bytes32 indexed arg1,\n', '        bytes32 indexed arg2,\n', '        uint256 msgValue,\n', '        bytes msgData\n', '    ) anonymous;\n', '\n', '    // returns the current value (ETH/USD * 10**18) as a bytes32\n', '    function peek()\n', '        external\n', '        view\n', '        returns (bytes32, bool);\n', '\n', '    // requires a fresh price and then returns the current value\n', '    function read()\n', '        external\n', '        view\n', '        returns (bytes32);\n', '}\n', '\n', '// File: contracts/external/interfaces/IOasisDex.sol\n', '\n', '/**\n', ' * @title IOasisDex\n', ' * @author dYdX\n', ' *\n', ' * Interface for the OasisDex contract\n', ' */\n', 'interface IOasisDex {\n', '\n', '    // ============ Structs ================\n', '\n', '    struct OfferInfo {\n', '        uint256 pay_amt;\n', '        address pay_gem;\n', '        uint256 buy_amt;\n', '        address buy_gem;\n', '        address owner;\n', '        uint64 timestamp;\n', '    }\n', '\n', '    struct SortInfo {\n', '        uint256 next;  //points to id of next higher offer\n', '        uint256 prev;  //points to id of previous lower offer\n', '        uint256 delb;  //the blocknumber where this entry was marked for delete\n', '    }\n', '\n', '    // ============ Storage Getters ================\n', '\n', '    function last_offer_id()\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function offers(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (OfferInfo memory);\n', '\n', '    function close_time()\n', '        external\n', '        view\n', '        returns (uint64);\n', '\n', '    function stopped()\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function buyEnabled()\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function matchingEnabled()\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function _rank(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (SortInfo memory);\n', '\n', '    function _best(\n', '        address sell_gem,\n', '        address buy_gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function _span(\n', '        address sell_gem,\n', '        address buy_gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function _dust(\n', '        address gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function _near(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    // ============ Constant Functions ================\n', '\n', '    function isActive(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function getOwner(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (address);\n', '\n', '    function getOffer(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (uint256, address, uint256, address);\n', '\n', '    function getMinSell(\n', '        address pay_gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getBestOffer(\n', '        address sell_gem,\n', '        address buy_gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getWorseOffer(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getBetterOffer(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getOfferCount(\n', '        address sell_gem,\n', '        address buy_gem\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getFirstUnsortedOffer()\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getNextUnsortedOffer(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function isOfferSorted(\n', '        uint256 id\n', '    )\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function getBuyAmount(\n', '        address buy_gem,\n', '        address pay_gem,\n', '        uint256 pay_amt\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getPayAmount(\n', '        address pay_gem,\n', '        address buy_gem,\n', '        uint256 buy_amt\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function isClosed()\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function getTime()\n', '        external\n', '        view\n', '        returns (uint64);\n', '\n', '    // ============ Non-Constant Functions ================\n', '\n', '    function bump(\n', '        bytes32 id_\n', '    )\n', '        external;\n', '\n', '    function buy(\n', '        uint256 id,\n', '        uint256 quantity\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    function cancel(\n', '        uint256 id\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    function kill(\n', '        bytes32 id\n', '    )\n', '        external;\n', '\n', '    function make(\n', '        address  pay_gem,\n', '        address  buy_gem,\n', '        uint128  pay_amt,\n', '        uint128  buy_amt\n', '    )\n', '        external\n', '        returns (bytes32);\n', '\n', '    function take(\n', '        bytes32 id,\n', '        uint128 maxTakeAmount\n', '    )\n', '        external;\n', '\n', '    function offer(\n', '        uint256 pay_amt,\n', '        address pay_gem,\n', '        uint256 buy_amt,\n', '        address buy_gem\n', '    )\n', '        external\n', '        returns (uint256);\n', '\n', '    function offer(\n', '        uint256 pay_amt,\n', '        address pay_gem,\n', '        uint256 buy_amt,\n', '        address buy_gem,\n', '        uint256 pos\n', '    )\n', '        external\n', '        returns (uint256);\n', '\n', '    function offer(\n', '        uint256 pay_amt,\n', '        address pay_gem,\n', '        uint256 buy_amt,\n', '        address buy_gem,\n', '        uint256 pos,\n', '        bool rounding\n', '    )\n', '        external\n', '        returns (uint256);\n', '\n', '    function insert(\n', '        uint256 id,\n', '        uint256 pos\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    function del_rank(\n', '        uint256 id\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    function sellAllAmount(\n', '        address pay_gem,\n', '        uint256 pay_amt,\n', '        address buy_gem,\n', '        uint256 min_fill_amount\n', '    )\n', '        external\n', '        returns (uint256);\n', '\n', '    function buyAllAmount(\n', '        address buy_gem,\n', '        uint256 buy_amt,\n', '        address pay_gem,\n', '        uint256 max_fill_amount\n', '    )\n', '        external\n', '        returns (uint256);\n', '}\n', '\n', '// File: contracts/external/oracles/DaiPriceOracle.sol\n', '\n', '/**\n', ' * @title DaiPriceOracle\n', ' * @author dYdX\n', ' *\n', ' * PriceOracle that gives the price of Dai in USD\n', ' */\n', 'contract DaiPriceOracle is\n', '    Ownable,\n', '    IPriceOracle\n', '{\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Constants ============\n', '\n', '    bytes32 constant FILE = "DaiPriceOracle";\n', '\n', '    uint256 constant DECIMALS = 18;\n', '\n', '    uint256 constant EXPECTED_PRICE = ONE_DOLLAR / (10 ** DECIMALS);\n', '\n', '    // ============ Structs ============\n', '\n', '    struct PriceInfo {\n', '        uint128 price;\n', '        uint32 lastUpdate;\n', '    }\n', '\n', '    struct DeviationParams {\n', '        uint64 denominator;\n', '        uint64 maximumPerSecond;\n', '        uint64 maximumAbsolute;\n', '    }\n', '\n', '    // ============ Events ============\n', '\n', '    event PriceSet(\n', '        PriceInfo newPriceInfo\n', '    );\n', '\n', '    // ============ Storage ============\n', '\n', '    PriceInfo public g_priceInfo;\n', '\n', '    address public g_poker;\n', '\n', '    DeviationParams public DEVIATION_PARAMS;\n', '\n', '    uint256 public OASIS_ETH_AMOUNT;\n', '\n', '    IErc20 public WETH;\n', '\n', '    IErc20 public DAI;\n', '\n', '    IMakerOracle public MEDIANIZER;\n', '\n', '    IOasisDex public OASIS;\n', '\n', '    address public UNISWAP;\n', '\n', '    // ============ Constructor =============\n', '\n', '    constructor(\n', '        address poker,\n', '        address weth,\n', '        address dai,\n', '        address medianizer,\n', '        address oasis,\n', '        address uniswap,\n', '        uint256 oasisEthAmount,\n', '        DeviationParams memory deviationParams\n', '    )\n', '        public\n', '    {\n', '        g_poker = poker;\n', '        MEDIANIZER = IMakerOracle(medianizer);\n', '        WETH = IErc20(weth);\n', '        DAI = IErc20(dai);\n', '        OASIS = IOasisDex(oasis);\n', '        UNISWAP = uniswap;\n', '        DEVIATION_PARAMS = deviationParams;\n', '        OASIS_ETH_AMOUNT = oasisEthAmount;\n', '        g_priceInfo = PriceInfo({\n', '            lastUpdate: uint32(block.timestamp),\n', '            price: uint128(EXPECTED_PRICE)\n', '        });\n', '    }\n', '\n', '    // ============ Admin Functions ============\n', '\n', '    function ownerSetPokerAddress(\n', '        address newPoker\n', '    )\n', '        external\n', '        onlyOwner\n', '    {\n', '        g_poker = newPoker;\n', '    }\n', '\n', '    // ============ Public Functions ============\n', '\n', '    function updatePrice(\n', '        Monetary.Price memory minimum,\n', '        Monetary.Price memory maximum\n', '    )\n', '        public\n', '        returns (PriceInfo memory)\n', '    {\n', '        Require.that(\n', '            msg.sender == g_poker,\n', '            FILE,\n', '            "Only poker can call updatePrice",\n', '            msg.sender\n', '        );\n', '\n', '        Monetary.Price memory newPrice = getBoundedTargetPrice();\n', '\n', '        Require.that(\n', '            newPrice.value >= minimum.value,\n', '            FILE,\n', '            "newPrice below minimum",\n', '            newPrice.value,\n', '            minimum.value\n', '        );\n', '\n', '        Require.that(\n', '            newPrice.value <= maximum.value,\n', '            FILE,\n', '            "newPrice above maximum",\n', '            newPrice.value,\n', '            maximum.value\n', '        );\n', '\n', '        g_priceInfo = PriceInfo({\n', '            price: Math.to128(newPrice.value),\n', '            lastUpdate: Time.currentTime()\n', '        });\n', '\n', '        emit PriceSet(g_priceInfo);\n', '        return g_priceInfo;\n', '    }\n', '\n', '    // ============ IPriceOracle Functions ============\n', '\n', '    function getPrice(\n', '        address /* token */\n', '    )\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        return Monetary.Price({\n', '            value: g_priceInfo.price\n', '        });\n', '    }\n', '\n', '    // ============ Price-Query Functions ============\n', '\n', '    /**\n', '     * Get the new price that would be stored if updated right now.\n', '     */\n', '    function getBoundedTargetPrice()\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        Monetary.Price memory targetPrice = getTargetPrice();\n', '\n', '        PriceInfo memory oldInfo = g_priceInfo;\n', '        uint256 timeDelta = uint256(Time.currentTime()).sub(oldInfo.lastUpdate);\n', '        (uint256 minPrice, uint256 maxPrice) = getPriceBounds(oldInfo.price, timeDelta);\n', '        uint256 boundedTargetPrice = boundValue(targetPrice.value, minPrice, maxPrice);\n', '\n', '        return Monetary.Price({\n', '            value: boundedTargetPrice\n', '        });\n', '    }\n', '\n', '    /**\n', '     * Get the USD price of DAI that this contract will move towards when updated. This price is\n', '     * not bounded by the variables governing the maximum deviation from the old price.\n', '     */\n', '    function getTargetPrice()\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        Monetary.Price memory ethUsd = getMedianizerPrice();\n', '\n', '        uint256 targetPrice = getMidValue(\n', '            EXPECTED_PRICE,\n', '            getOasisPrice(ethUsd).value,\n', '            getUniswapPrice(ethUsd).value\n', '        );\n', '\n', '        return Monetary.Price({\n', '            value: targetPrice\n', '        });\n', '    }\n', '\n', '    /**\n', '     * Get the USD price of ETH according the Maker Medianizer contract.\n', '     */\n', '    function getMedianizerPrice()\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        // throws if the price is not fresh\n', '        return Monetary.Price({\n', '            value: uint256(MEDIANIZER.read())\n', '        });\n', '    }\n', '\n', '    /**\n', '     * Get the USD price of DAI according to OasisDEX given the USD price of ETH.\n', '     */\n', '    function getOasisPrice(\n', '        Monetary.Price memory ethUsd\n', '    )\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        IOasisDex oasis = OASIS;\n', '\n', '        // If exchange is not operational, return old value.\n', '        // This allows the price to move only towards 1 USD\n', '        if (\n', '            oasis.isClosed()\n', '            || !oasis.buyEnabled()\n', '            || !oasis.matchingEnabled()\n', '        ) {\n', '            return Monetary.Price({\n', '                value: g_priceInfo.price\n', '            });\n', '        }\n', '\n', '        uint256 numWei = OASIS_ETH_AMOUNT;\n', '        address dai = address(DAI);\n', '        address weth = address(WETH);\n', '\n', '        // Assumes at least `numWei` of depth on both sides of the book if the exchange is active.\n', '        // Will revert if not enough depth.\n', '        uint256 daiAmt1 = oasis.getBuyAmount(dai, weth, numWei);\n', '        uint256 daiAmt2 = oasis.getPayAmount(dai, weth, numWei);\n', '\n', '        uint256 num = numWei.mul(daiAmt2).add(numWei.mul(daiAmt1));\n', '        uint256 den = daiAmt1.mul(daiAmt2).mul(2);\n', '        uint256 oasisPrice = Math.getPartial(ethUsd.value, num, den);\n', '\n', '        return Monetary.Price({\n', '            value: oasisPrice\n', '        });\n', '    }\n', '\n', '    /**\n', '     * Get the USD price of DAI according to Uniswap given the USD price of ETH.\n', '     */\n', '    function getUniswapPrice(\n', '        Monetary.Price memory ethUsd\n', '    )\n', '        public\n', '        view\n', '        returns (Monetary.Price memory)\n', '    {\n', '        address uniswap = address(UNISWAP);\n', '        uint256 ethAmt = uniswap.balance;\n', '        uint256 daiAmt = DAI.balanceOf(uniswap);\n', '        uint256 uniswapPrice = Math.getPartial(ethUsd.value, ethAmt, daiAmt);\n', '\n', '        return Monetary.Price({\n', '            value: uniswapPrice\n', '        });\n', '    }\n', '\n', '    // ============ Helper Functions ============\n', '\n', '    function getPriceBounds(\n', '        uint256 oldPrice,\n', '        uint256 timeDelta\n', '    )\n', '        private\n', '        view\n', '        returns (uint256, uint256)\n', '    {\n', '        DeviationParams memory deviation = DEVIATION_PARAMS;\n', '\n', '        uint256 maxDeviation = Math.getPartial(\n', '            oldPrice,\n', '            Math.min(deviation.maximumAbsolute, timeDelta.mul(deviation.maximumPerSecond)),\n', '            deviation.denominator\n', '        );\n', '\n', '        return (\n', '            oldPrice.sub(maxDeviation),\n', '            oldPrice.add(maxDeviation)\n', '        );\n', '    }\n', '\n', '    function getMidValue(\n', '        uint256 valueA,\n', '        uint256 valueB,\n', '        uint256 valueC\n', '    )\n', '        private\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        uint256 maximum = Math.max(valueA, Math.max(valueB, valueC));\n', '        if (maximum == valueA) {\n', '            return Math.max(valueB, valueC);\n', '        }\n', '        if (maximum == valueB) {\n', '            return Math.max(valueA, valueC);\n', '        }\n', '        return Math.max(valueA, valueB);\n', '    }\n', '\n', '    function boundValue(\n', '        uint256 value,\n', '        uint256 minimum,\n', '        uint256 maximum\n', '    )\n', '        private\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        assert(minimum <= maximum);\n', '        return Math.max(minimum, Math.min(maximum, value));\n', '    }\n', '}']