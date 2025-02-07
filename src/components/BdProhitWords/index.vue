<template>
  <el-dialog
    :model-value="value"
    :width="600"
    :align-center="true"
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    :draggable="true"
    :z-index="99"
    title="添加违禁词"
    @close="onClose"
  >
    <div>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="手动添加" name="manual">
          <el-input v-model="content" :rows="6" type="textarea" placeholder="请输入违禁词" />
        </el-tab-pane>
        <el-tab-pane label="批量导入" name="batch">
          <el-upload
            class="upload-demo"
            drag
            action=""
            :auto-upload="false"
            :show-file-list="true"
            :on-change="handleFileChange"
            :multiple="true"
            accept=".txt"
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              将文件拖到此处，或<em>点击上传</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">
                请上传txt文本文件,文件中每行一个违禁词,支持多个文件上传
              </div>
            </template>
          </el-upload>
        </el-tab-pane>
      </el-tabs>
    </div>
    <template #footer>
      <el-space>
        <el-button @click="onClose">取消</el-button>
        <el-button type="primary" :loading="loaging" @click="onSend">发送</el-button>
      </el-space>
    </template>
  </el-dialog>
</template>

<script lang="ts" name="BdProhitWords" setup>
import { ref } from 'vue';
import { ElMessage } from 'element-plus';
import { UploadFilled } from '@element-plus/icons-vue';
// API 接口
import { messageProhibitWordsPost, messageProhibitWordsBatchPost } from '@/api/message';
interface IProps {
  value: boolean;
}
const props = withDefaults(defineProps<IProps>(), {
  value: false
});

const content = ref('');
const loaging = ref<boolean>(false);
const activeTab = ref('manual');
const uploadFiles = ref<File[]>([]);

const emits = defineEmits<{
  (e: 'update:value', item: boolean): void;
  (e: 'ok', item: any): void;
}>();

watch(
  () => props.value,
  (n, _o) => {
    console.log(props.value);
    props.value = n;
  }
);

// 取消
const onClose = () => {
  content.value = '';
  uploadFiles.value = [];
  activeTab.value = 'manual';
  emits('update:value', false);
};

// 处理文件变化
const handleFileChange = (file: any, fileList: any[]) => {
  uploadFiles.value = fileList.map(f => f.raw);
};

// 发送
const onSend = () => {
  if (activeTab.value === 'manual') {
    if (!content.value) {
      return ElMessage.info('请输入违禁词！');
    }
    const fromData = {
      content: content.value
    };
    loaging.value = true;
    messageProhibitWordsPost(fromData)
      .then((res: any) => {
        loaging.value = false;
        if (res.status == 200) {
          ElMessage.success('发送成功！');
          content.value = '';
          onClose();
          emits('ok', true);
        }
      })
      .catch(err => {
        loaging.value = false;
        if (err.status == 400) {
          ElMessage.error(err.msg);
        }
      });
  } else {
    if (uploadFiles.value.length === 0) {
      return ElMessage.info('请选择要上传的文件！');
    }
    const formData = new FormData();
    uploadFiles.value.forEach(file => {
      formData.append('files', file);
    });
    loaging.value = true;
    messageProhibitWordsBatchPost(formData)
      .then((res: any) => {
        loaging.value = false;
        if (res.status == 200) {
          ElMessage.success('批量添加成功！');
          uploadFiles.value = [];
          onClose();
          emits('ok', true);
        }
      })
      .catch(err => {
        loaging.value = false;
        if (err.status == 400) {
          ElMessage.error(err.msg);
        }
      });
  }
};
</script>
