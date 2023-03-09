## Cocoapods-sanbox

#### pod缓存管理组件

支持针对组件实现缓存功能，同时提供checkout、clean、list等功能

### 使用

#### 1. Add

> 添加一个repo缓存

##### 1.1 Arguments

- name（可选）
- repo

##### 1.2 使用

`pod sandbox add #{name} #{ssh://xxxx.git}`

#### 2. checkout

> 从缓存中拉出一份最新代码 ，支持定制分支，以及checkout路径

##### 2.1 Arguments

- repo

##### 2.2 Options

- --branch （可选）
- --path（可选）

##### 2.3 使用

`pod sandbox checkout #{ssh://xxxx.git} --path=master --path=/User/xxx/..`

#### 3. clean

> 清理缓存管理

##### 3.1 Options

- --all（可选）
- --name（可选）
- --repo（可选）

> **任何参数不加，默认清理全部**

##### 3.2 使用

`pod sandbox clean`

#### 4. list

##### 4.1 Arguments

- name（可选）

> 不加name，打印出所有已缓存的组件以及sshUrl

##### 4.2 使用

`pod sandbox list #{name}`
