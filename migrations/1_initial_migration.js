const Token = artifacts.require("Token");
const Pool = artifacts.require("Pool");

module.exports =async function (deployer) {

    await deployer.deploy(Token);
    const tokenContract=await Token.deployed();

    await deployer.deploy(Pool,tokenContract.address);
    const poolContract=await Pool.deployed();


    console.log("token ",tokenContract.address);
    console.log("pool ",poolContract.address);
};
