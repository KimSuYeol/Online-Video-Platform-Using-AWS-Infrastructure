## AWS 인프라를 활용한 온라인 동영상/스트리밍 플랫폼

### Architecture
<img width="802" alt="image" src="https://github.com/user-attachments/assets/58a323d7-44bd-438f-9947-84608dd67ebe">


## 

<table>

  <tr>
    <td colspan="2" style="text-align: center;">
      AWS MediaConvert
    </td>
  </tr>
  
  <tr>
    <td>
      <h3> HLS 변환 과정 </h3>
      <br>
      <img width="429" alt="image" src="https://github.com/user-attachments/assets/eae5e18f-8899-41be-86ba-34b996d2669d">
    </td>
    <td>
      <h3> MediaConvert 템플릿 설정 </h3>
      <br>
      <img width="539" alt="image" src="https://github.com/user-attachments/assets/ed4a0ac2-4473-4f55-8f6f-7fdaa66d1b59">
    </td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: center;">
      Network + ALB
    </td>
  </tr>
  
  <tr>
    <td>
      <h3> VPC 구성 </h3>
      <br>
      <img width="603" alt="image" src="https://github.com/user-attachments/assets/edf2e8a4-c9f6-49f8-8076-39386d4cc5c4">
    </td>
    <td>
      <h3> ALB 구성/Ingress 확인 </h3>
      <br>
      <img width="613" alt="image" src="https://github.com/user-attachments/assets/4f1b9dfd-91af-490a-bbdf-abdc3173b7d0">
      <img width="662" alt="image" src="https://github.com/user-attachments/assets/58d9a1b8-4b8d-4e4d-ae72-3f1e6a90d32c">
    </td>
  </tr>



  <tr>
    <td colspan="2" style="text-align: center;">
      Cluster Over Provisioning
    </td>
  </tr>

  

  <tr>
    <td>
      <h3> PriorityClass 우선순위 생성 </h3>
      <br>
      <img width="492" alt="image" src="https://github.com/user-attachments/assets/8b51aada-f2ef-448e-b4e3-a664994c65c7">
    </td>
    <td>
      <h3> pause pod 배포 + 상태 확인 </h3>
      <br>
      <img width="186" alt="image" src="https://github.com/user-attachments/assets/b04285d7-8c66-45f6-b5c8-0d9fb89ddc62">
      <img width="620" alt="image" src="https://github.com/user-attachments/assets/fd8de049-de65-419a-80e6-22ec1bc1a360">
    </td>
  </tr>
  
  <tr>
    <td colspan="2" style="text-align: center;">
      Horizontal Pod Autoscaler
    </td>
  </tr>

  <tr>
    <td>
      <h3> HPA cpu 50% </h3>
      <br>
      <img width="235" alt="image" src="https://github.com/user-attachments/assets/649fb04f-e13e-4590-a603-ce51dcdf76a7">
    </td>
    <td>
      <h3> 스케일링 확인 </h3>
      <br>
      <img width="750" alt="image" src="https://github.com/user-attachments/assets/2c0fbd3a-a30f-4e46-b764-aca8b459d969">
    </td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: center;">
      Congito 인증/인가
    </td>
  </tr>

  <tr>
    <td>
      <h3> Client (amazon-cognito-identity-js) </h3>
      <br>
      <img width="561" alt="image" src="https://github.com/user-attachments/assets/67323322-89da-41fa-bb41-6cd1d0e938d5">
      <img width="367" alt="image" src="https://github.com/user-attachments/assets/15358ecf-7ffe-48f8-bffa-6be82c5bf1e8">
    </td>
    <td>
      <h3> Server (FastAPI) </h3>
      <br>
      <img width="367" alt="image" src="https://github.com/user-attachments/assets/48f94199-003a-4ec3-8888-78c2f9bda69d">
    </td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: center;">
      IRSA(IAM Roles for Service Accounts)
    </td>
  </tr>

  <tr>
    <td>
      <h3> Services Account + IAM role </h3>
      <br>
      <img width="463" alt="image" src="https://github.com/user-attachments/assets/84152e81-11ae-4285-8f2a-3c73c2f58ad6">
    </td>
    <td>
      <h3> ServiceAccountName(Deployment) </h3>
      <br>
      <img width="340" alt="image" src="https://github.com/user-attachments/assets/5991723f-b74a-4140-88a4-e0f428e9d35c">
    </td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: center;">
      CI/CD
    </td>
  </tr>

  <tr>
    <td>
      <h3> Github Actions </h3>
      <br>
      <img width="461" alt="image" src="https://github.com/user-attachments/assets/f950ec02-43d9-486d-abfb-ac7fb508d472">
    </td>
    <td>
      <h3> ArgoCD </h3>
      <br>
      <img width="704" alt="image" src="https://github.com/user-attachments/assets/80f00a87-110d-41cc-98c5-8b30b19345f8">
    </td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: center;">
      Observability
    </td>
  </tr>

  <tr>
    <td>
      <h3> monitoring </h3>
      <br>
      <img width="590" alt="image" src="https://github.com/user-attachments/assets/20f96011-1c3e-4fac-bce0-59bb1ff8d194">
    </td>
    <td>
      <h3> service mesh </h3>
      <br>
      <img width="459" alt="image" src="https://github.com/user-attachments/assets/8462e046-5450-4152-9401-bb5aa60577b0">
      <img width="526" alt="image" src="https://github.com/user-attachments/assets/fee0f77f-9541-4044-a9d9-a69a9c884f3b">
    </td>
  </tr>

  
</table>
