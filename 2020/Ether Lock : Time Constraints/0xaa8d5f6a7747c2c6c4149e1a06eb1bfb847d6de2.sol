['pragma solidity 0.6.10;\n', '\n', 'abstract contract YPool {\n', '    function get_virtual_price() external view virtual returns (uint256);\n', '}\n', '\n', 'contract APYOracle {\n', '    YPool public pool;\n', '    uint256 public poolDeployBlock;\n', '    uint256 constant blocksPerYear = 242584;\n', '    \n', '    constructor(YPool _pool, uint256 _poolDeployBlock) public {\n', '        pool = _pool;\n', '        poolDeployBlock = _poolDeployBlock;\n', '    }\n', '    \n', '    function getAPY() external view returns (uint256) {\n', '        uint256 blocks = block.number - poolDeployBlock;\n', '\t\tuint256 price = pool.get_virtual_price() - 1e18;\n', '        return price * blocksPerYear / blocks;\n', '    }\n', '}']