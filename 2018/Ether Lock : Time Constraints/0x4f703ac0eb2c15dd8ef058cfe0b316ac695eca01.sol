['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/IOneInchTrade.sol\n', '\n', 'interface IOneInchTrade {\n', '\n', '    function getRateFromKyber(IERC20 from, IERC20 to, uint amount) external view returns (uint expectedRate, uint slippageRate);\n', '    function getRateFromBancor(IERC20 from, IERC20 to, uint amount) external view returns (uint expectedRate, uint slippageRate);\n', '}\n', '\n', '// File: contracts/KyberNetworkProxy.sol\n', '\n', 'interface KyberNetworkProxy {\n', '\n', '    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)\n', '    external view\n', '    returns (uint expectedRate, uint slippageRate);\n', '}\n', '\n', '// File: contracts/BancorConverter.sol\n', '\n', 'interface BancorConverter {\n', '\n', '    function getReturn(IERC20 _fromToken, IERC20 _toToken, uint256 _amount) external view returns (uint256, uint256);\n', '}\n', '\n', '// File: contracts/OneInchTrade.sol\n', '\n', '/**\n', '* KyberNetworkProxy mainnet address 0x818E6FECD516Ecc3849DAf6845e3EC868087B755\n', '* BancorConverter mainnet address 0xb89570f6AD742CB1fd440A930D6c2A2eA29c51eE\n', '\n', '* DSToken mainnet address 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359\n', '* Bancor Token mainnet address 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C\n', '**/\n', 'contract OneInchTrade is IOneInchTrade {\n', '\n', '    uint constant MIN_TRADING_AMOUNT = 0.0001 ether;\n', '\n', '    KyberNetworkProxy public kyberNetworkProxy;\n', '    BancorConverter public bancorConverter;\n', '\n', '    address public dsTokenAddress;\n', '    address public bntTokenAddress;\n', '\n', '    address constant public KYBER_ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    address constant public BANCOR_ETHER_ADDRESS = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;\n', '\n', '    constructor(\n', '        address kyberNetworkProxyAddress,\n', '        address bancorConverterAddress,\n', '\n', '        address _dsTokenAddress,\n', '        address _bntTokenAddress\n', '    ) public {\n', '\n', '        kyberNetworkProxy = KyberNetworkProxy(kyberNetworkProxyAddress);\n', '        bancorConverter = BancorConverter(bancorConverterAddress);\n', '\n', '        dsTokenAddress = _dsTokenAddress;\n', '        bntTokenAddress = _bntTokenAddress;\n', '    }\n', '\n', '    function getRateFromKyber(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {\n', '\n', '        return kyberNetworkProxy.getExpectedRate(\n', '            from,\n', '            to,\n', '            amount\n', '        );\n', '    }\n', '\n', '    function getRateFromBancor(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {\n', '\n', '        return bancorConverter.getReturn(\n', '            from,\n', '            to,\n', '            amount\n', '        );\n', '    }\n', '\n', '    function() external payable {\n', '\n', '        uint startGas = gasleft();\n', '\n', '        require(msg.value >= MIN_TRADING_AMOUNT, "Min trading amount not reached.");\n', '\n', '        IERC20 bntToken = IERC20(bntTokenAddress);\n', '        IERC20 dsToken = IERC20(dsTokenAddress);\n', '\n', '        (uint kyberExpectedRate, uint kyberSlippageRate) = getRateFromKyber(\n', '            IERC20(KYBER_ETHER_ADDRESS),\n', '            dsToken,\n', '            msg.value\n', '        );\n', '\n', '        (uint bancorBNTExpectedRate, uint bancorBNTSlippageRate) = getRateFromBancor(\n', '            IERC20(BANCOR_ETHER_ADDRESS),\n', '            bntToken,\n', '            msg.value\n', '        );\n', '\n', '        (uint bancorDSExpectedRate, uint bancorDSSlippageRate) = getRateFromBancor(\n', '            bntToken,\n', '            dsToken,\n', '            msg.value\n', '        );\n', '\n', '        uint kyberRate = kyberExpectedRate * msg.value;\n', '        uint bancorRate = bancorBNTExpectedRate * msg.value * bancorDSExpectedRate;\n', '\n', '        uint baseTokenAmount = 0;\n', '        uint tradedResult = 0;\n', '\n', '        if (kyberRate > bancorRate) {\n', '            // buy from kyber and sell to bancor\n', '            tradedResult = kyberRate - bancorRate;\n', '            baseTokenAmount = bancorRate * msg.value;\n', '\n', '        } else {\n', '            // buy from kyber and sell to bancor\n', '            tradedResult = bancorRate - kyberRate;\n', '            baseTokenAmount = kyberRate * msg.value;\n', '        }\n', '\n', '        require(\n', '            tradedResult >= baseTokenAmount,\n', '            "Canceled because of not profitable trade."\n', '        );\n', '\n', '        //uint gasUsed = startGas - gasleft();\n', '        // gasUsed * tx.gasprice\n', '    }\n', '}']